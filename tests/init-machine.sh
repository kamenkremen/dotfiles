#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
# shellcheck source=../scripts/init-machine.sh
source "$repo_dir/scripts/init-machine.sh"
test_dir=$(mktemp -d)
trap 'rm -rf -- "$test_dir"' EXIT

assert_equal() {
  [[ $1 == "$2" ]] || fail "Expected <$2>, got <$1>."
}

# Run the real CLI in a separate shell so its error handling and traps behave
# normally. Only Nix's network-dependent lock operation is substituted.
run_init() {
  bash -c '
    source "$1/scripts/init-machine.sh"
    template_dir="$1/templates/machine"
    shift
    nix() {
      if [[ $3 == eval ]]; then
        command nix "$@"
        return
      fi
      [[ $# == 5 && $1 == --extra-experimental-features && $2 == "nix-command flakes" && $3 == flake && $4 == lock && $5 == path:. ]] || return 2
      [[ ${INIT_TEST_LOCK_FAIL:-0} == 0 ]] || return 23
      printf "{\"version\":7}\n" > flake.lock
    }
    main "$@"
  ' init-machine-test "$repo_dir" "$@" </dev/null
}

expect_failure() {
  local expected=$1
  shift
  if run_init "$@" > "$test_dir/output" 2>&1; then
    fail "Unexpected success: $*"
  fi
  grep -Fq -- "$expected" "$test_dir/output" || {
    cat "$test_dir/output" >&2
    fail "Missing error message: $expected"
  }
}

cat > "$test_dir/hardware.nix" <<'EOF'
{...}: {
  nixpkgs.hostPlatform = "x86_64-linux";
  fileSystems."/" = { device = "/dev/disk/by-label/test-root"; fsType = "ext4"; };
}
EOF

# The version suggestion must not invent a value or pick between assignments.
printf '%s\n' '# system.stateVersion = "23.11";' '  system.stateVersion = "24.11"; # keep this' > "$test_dir/config.nix"
assert_equal "$(suggest_state_version "$test_dir/config.nix")" 24.11
printf '%s\n' 'system.stateVersion = "25.05";' >> "$test_dir/config.nix"
assert_equal "$(suggest_state_version "$test_dir/config.nix")" ''
printf '%s\n' 'system.stateVersion = config.system.nixos.release;' > "$test_dir/config.nix"
assert_equal "$(suggest_state_version "$test_dir/config.nix")" ''
printf '%s\n' '/*' 'system.stateVersion = "24.11";' '*/' > "$test_dir/config.nix"
assert_equal "$(suggest_state_version "$test_dir/config.nix")" ''
assert_equal "$(suggest_state_version "$test_dir/nonexistent.nix")" ''
assert_equal "$(printf '\n' | prompt_version version 24.11 2>/dev/null)" 24.11
assert_equal "$(printf 'invalid\n26.05\n' | prompt_version version '' 2>/dev/null)" 26.05
valid_version 20.09

# Quotes, interpolation, backslashes, ampersands and shell syntax remain data.
# shellcheck disable=SC2016
for value in 'plain' 'a"b\c & ${notEvaluated} $(not-run)' $'a\nb\tc\r'; do
  escaped=$(nix_string "$value")
  assert_equal "$(nix-instantiate --eval --expr "{expected}: $escaped == expected" --argstr expected "$value")" true
done

destination="$test_dir/parent with spaces/machine with spaces"
# shellcheck disable=SC2016,SC1003
library_ref='path:/tmp/library with "quotes" & ${notEvaluated} $(not-run) \'
run_init --dir "$destination" --hardware "$test_dir/hardware.nix" \
  --host test-laptop --user alice --state-version 24.11 --home-state-version 26.05 \
  --dotfiles "$library_ref" > "$test_dir/output"
cmp "$test_dir/hardware.nix" "$destination/hardware-configuration.nix"
[[ -s $destination/flake.lock && -f $destination/.gitignore ]]
grep -Fq 'sudo nixos-rebuild switch' "$test_dir/output"
grep -Fq 'NIXOS_CONFIG_DIR=' "$test_dir/output"
assert_equal "$(nix-instantiate --eval --strict --expr '
  {directory, expectedRef}:
  let
    c = import (builtins.toPath (directory + "/machine.nix"));
    f = import (builtins.toPath (directory + "/flake.nix"));
  in c.hostName == "test-laptop" && c.username == "alice"
    && c.stateVersion == "24.11" && c.homeStateVersion == "26.05"
    && builtins.length c.modules == 1 && builtins.length c.homeModules == 1
    && builtins.isFunction (import (builtins.head c.modules))
    && builtins.isFunction (import (builtins.head c.homeModules))
    && f.inputs.dotfiles.url == expectedRef
' --argstr directory "$destination" --argstr expectedRef "$library_ref")" true

default_dir="$test_dir/defaults"
mkdir "$default_dir"
run_init --dir "$default_dir" --hardware "$test_dir/hardware.nix" \
  --state-version 24.11 > "$test_dir/output"
assert_equal "$(nix-instantiate --eval --expr '
  {directory, host, user}:
  let
    c = import (builtins.toPath (directory + "/machine.nix"));
    f = import (builtins.toPath (directory + "/flake.nix"));
  in c.hostName == host && c.username == user
    && c.homeStateVersion == c.stateVersion
    && f.inputs.dotfiles.url == "github:kamenkremen/dotfiles?ref=reusable-config"
' --argstr directory "$default_dir" --argstr host "$(uname -n)" --argstr user "$(id -un)")" true

mkdir "$test_dir/library with spaces"
run_init --dir "$test_dir/local-source" --hardware "$test_dir/hardware.nix" \
  --state-version 24.11 --dotfiles "path:$test_dir/library with spaces" > "$test_dir/output"
assert_equal "$(nix-instantiate --eval --expr '
  {directory, sourcePath}:
  let f = import (builtins.toPath (directory + "/flake.nix"));
  in (builtins.parseFlakeRef f.inputs.dotfiles.url).path == sourcePath
' --argstr directory "$test_dir/local-source" --argstr sourcePath "$test_dir/library with spaces")" true

common=(--dir "$test_dir/rejected" --hardware "$test_dir/hardware.nix")
expect_failure 'Pass --state-version' "${common[@]}"
expect_failure 'Invalid --state-version' "${common[@]}" --state-version 26.13
expect_failure 'Invalid --home-state-version' "${common[@]}" --state-version 24.11 --home-state-version invalid
expect_failure 'Cannot read hardware module' "${common[@]}" --hardware "$test_dir/missing.nix" --state-version 24.11
expect_failure 'Missing value for --user' --user
expect_failure 'Unknown argument' --switch
expect_failure 'Use an absolute path' "${common[@]}" --state-version 24.11 --dotfiles path:../library
[[ ! -e $test_dir/rejected ]]

mkdir "$test_dir/occupied"
printf 'keep me\n' > "$test_dir/occupied/.hidden"
expect_failure 'Destination is not empty' "${common[@]}" --dir "$test_dir/occupied" --state-version 24.11
assert_equal "$(cat "$test_dir/occupied/.hidden")" 'keep me'
ln -s "$test_dir/occupied" "$test_dir/symlink"
expect_failure 'Destination is a symlink' "${common[@]}" --dir "$test_dir/symlink" --state-version 24.11

# Lock failures leave neither a completed destination nor a staging directory.
if INIT_TEST_LOCK_FAIL=1 run_init "${common[@]}" --state-version 24.11 > "$test_dir/output" 2>&1; then
  fail 'Lock failure was ignored.'
fi
[[ ! -e $test_dir/rejected ]]
shopt -s nullglob
leftovers=("$test_dir"/.init-machine.*)
[[ ${#leftovers[@]} == 0 ]]

printf 'init-machine tests passed\n'
