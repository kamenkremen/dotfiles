#!/usr/bin/env bash

set -euo pipefail

fail() {
  printf 'init-machine: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: init-machine [OPTIONS]

Prepare a machine flake on an existing x86_64-linux NixOS installation.
Run as your normal user. This only creates files and a lock file.

  --dir PATH                 Destination (default: ~/nixos-configs/<host>)
  --host NAME                Hostname (default: current hostname)
  --user NAME                Username (default: current user)
  --hardware PATH            Hardware module (default: /etc/nixos/hardware-configuration.nix)
  --state-version YY.MM      Existing system.stateVersion; required without a terminal
  --home-state-version YY.MM Existing home.stateVersion (default: system state version)
  --dotfiles REF             Library input (default: reusable-config branch)
                            For a local checkout, use path:/absolute/path/to/dotfiles
  --help                     Show this help

In a terminal, missing state versions are prompted for. Preserve existing
values when migrating; these are not the versions of packages to install.
EOF
}

valid_version() {
  [[ $1 =~ ^[0-9]{2}\.(0[1-9]|1[0-2])$ ]]
}

suggest_state_version() {
  local config_file=$1
  local -a assignments=()
  local literal='^[[:space:]]*system\.stateVersion[[:space:]]*=[[:space:]]*"([0-9]{2}\.(0[1-9]|1[0-2]))"[[:space:]]*;[[:space:]]*(#.*)?$'
  [[ -f $config_file && -r $config_file ]] || return 0
  # Be conservative around block comments and indented strings. This is only
  # a suggestion from a simple assignment, never an unattended default.
  if grep -q -e '/\*' -e "''" -- "$config_file"; then
    return 0
  fi
  mapfile -t assignments < <(grep -E '^[[:space:]]*system\.stateVersion[[:space:]]*=' -- "$config_file" || true)
  if [[ ${#assignments[@]} == 1 && ${assignments[0]} =~ $literal ]]; then
    printf '%s' "${BASH_REMATCH[1]}"
  fi
}

prompt_version() {
  local label=$1 default=$2 answer
  while true; do
    printf '%s%s: ' "$label" "${default:+ [$default]}" >&2
    IFS= read -r answer || fail "No answer received; pass the state versions as options."
    answer=${answer:-$default}
    if valid_version "$answer"; then
      printf '%s' "$answer"
      return
    fi
    printf 'Enter an existing state version such as 24.11 or 25.05.\n' >&2
  done
}

# Nix double-quoted strings need interpolation escaped as well as quotes.
nix_string() {
  local value=$1
  value=${value//\\/\\\\}
  value=${value//\"/\\\"}
  value=${value//\$\{/\\\$\{}
  value=${value//$'\n'/\\n}
  value=${value//$'\r'/\\r}
  value=${value//$'\t'/\\t}
  printf '"%s"' "$value"
}

replace_assignment() {
  local file=$1 name=$2 replacement=$3 contents line match='' count=0
  contents=$(cat -- "$file")
  while IFS= read -r line; do
    if [[ $line == "  $name = "* ]]; then
      match=$line
      count=$((count + 1))
    fi
  done <<< "$contents"
  [[ $count == 1 ]] || fail "Expected one $name assignment in template $file."
  contents=${contents/"$match"/"$replacement"}
  printf '%s\n' "$contents" > "$file"
}

empty_directory() (
  shopt -s nullglob dotglob
  local -a entries=("$1"/*)
  [[ ${#entries[@]} == 0 ]]
)

main() {
  local machine_dir='' machine_host='' machine_user='' state_version='' home_version='' dotfiles_ref=''
  local hardware_file=/etc/nixos/hardware-configuration.nix suggested parent

  while (($#)); do
    case $1 in
      --help|-h) usage; return ;;
      --dir|--host|--user|--hardware|--state-version|--home-state-version|--dotfiles)
        [[ $# -ge 2 && -n $2 && $2 != --* ]] || fail "Missing value for $1."
        case $1 in
          --dir) machine_dir=$2 ;;
          --host) machine_host=$2 ;;
          --user) machine_user=$2 ;;
          --hardware) hardware_file=$2 ;;
          --state-version) state_version=$2 ;;
          --home-state-version) home_version=$2 ;;
          --dotfiles) dotfiles_ref=$2 ;;
        esac
        shift 2
        ;;
      *) fail "Unknown argument: $1. See --help." ;;
    esac
  done

  ((EUID != 0)) || fail "Run as your normal user, without sudo."
  machine_host=${machine_host:-$(uname -n)}
  machine_user=${machine_user:-$(id -un)}
  [[ ${#machine_host} -le 63 && $machine_host =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$ ]] || fail "Invalid hostname: $machine_host. Use --host."
  [[ $machine_user != root && $machine_user =~ ^[a-zA-Z_][a-zA-Z0-9_.-]*\$?$ ]] || fail "Invalid normal username: $machine_user. Use --user."
  [[ -f $hardware_file && -r $hardware_file ]] || fail "Cannot read hardware module $hardware_file. Supply this device's file with --hardware."
  if [[ $dotfiles_ref == path:* && $dotfiles_ref != path:/* ]]; then
    fail "Use an absolute path in --dotfiles, such as path:/home/me/dotfiles."
  fi

  machine_dir=${machine_dir:-${HOME:?}/nixos-configs/$machine_host}
  [[ ! -L $machine_dir ]] || fail "Destination is a symlink: $machine_dir."
  machine_dir=$(realpath -m -- "$machine_dir")
  if [[ -e $machine_dir ]]; then
    [[ -d $machine_dir && -r $machine_dir && -x $machine_dir ]] || fail "Destination is not an accessible directory: $machine_dir."
    empty_directory "$machine_dir" || fail "Destination is not empty: $machine_dir. No files were changed."
  fi

  if [[ -z $state_version ]]; then
    [[ -t 0 ]] || fail "Pass --state-version when running without a terminal."
    suggested=$(suggest_state_version /etc/nixos/configuration.nix)
    printf 'Preserve the state versions from your existing installation.\n' >&2
    if [[ -n $suggested ]]; then
      printf 'Found %s in /etc/nixos/configuration.nix; confirm it matches your configuration.\n' "$suggested" >&2
    fi
    state_version=$(prompt_version system.stateVersion "$suggested")
  fi
  valid_version "$state_version" || fail "Invalid --state-version: $state_version. Expected YY.MM."
  if [[ -z $home_version ]]; then
    if [[ -t 0 ]]; then
      home_version=$(prompt_version 'home.stateVersion (preserve its old value if migrating Home Manager)' "$state_version")
    else
      home_version=$state_version
    fi
  fi
  valid_version "$home_version" || fail "Invalid --home-state-version: $home_version. Expected YY.MM."
  [[ -d ${template_dir:-} ]] || fail "Template unavailable. Launch this script with nix run ...#init-machine."

  # Accept literal local directory names as well as already encoded flake URLs.
  if [[ $dotfiles_ref == path:/* && -d ${dotfiles_ref#path:} ]]; then
    dotfiles_ref=$(nix --extra-experimental-features 'nix-command flakes' eval --raw \
      --expr "builtins.flakeRefToString { type = \"path\"; path = $(nix_string "${dotfiles_ref#path:}"); }")
  fi

  parent=$(dirname -- "$machine_dir")
  mkdir -p -- "$parent"
  init_staging_dir=$(mktemp -d -- "$parent/.init-machine.XXXXXXXX")
  trap 'rm -rf -- "$init_staging_dir"' EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM
  cp -R -- "$template_dir/." "$init_staging_dir/"
  chmod -R u+w -- "$init_staging_dir"
  cp -- "$hardware_file" "$init_staging_dir/hardware-configuration.nix"

  replace_assignment "$init_staging_dir/machine.nix" hostName "  hostName = $(nix_string "$machine_host");"
  replace_assignment "$init_staging_dir/machine.nix" username "  username = $(nix_string "$machine_user");"
  replace_assignment "$init_staging_dir/machine.nix" stateVersion \
    "  stateVersion = $(nix_string "$state_version");"$'\n'"  homeStateVersion = $(nix_string "$home_version");"
  if [[ -n $dotfiles_ref ]]; then
    replace_assignment "$init_staging_dir/flake.nix" inputs.dotfiles.url "  inputs.dotfiles.url = $(nix_string "$dotfiles_ref");"
  fi

  printf 'Preparing %s for %s in %s\n' "$machine_host" "$machine_user" "$machine_dir"
  (
    cd -- "$init_staging_dir"
    nix --extra-experimental-features 'nix-command flakes' flake lock path:.
  )
  # A directory rename also refuses to replace a destination that became
  # nonempty while the lock file was being prepared.
  mv -T -- "$init_staging_dir" "$machine_dir"
  trap - EXIT INT TERM

  printf '\nCreated %s\n' "$machine_dir"
  printf 'Review system.nix for bootloader/disk settings and home.nix for user settings.\n'
  printf 'Keep flake.lock with these files; add new files before using a Git-backed flake.\n\n'
  printf 'Build and apply:\n  cd %q\n' "$machine_dir"
  cat <<'EOF'
  nix --extra-experimental-features 'nix-command flakes' build 'path:.#nixosConfigurations.local.config.system.build.toplevel'
  sudo nixos-rebuild switch --flake 'path:.#local'

Update the shared configuration from this directory:
  nix --extra-experimental-features 'nix-command flakes' flake update dotfiles --flake path:.
EOF
  if [[ $machine_dir != "${HOME}/nixos-configs/$machine_host" ]]; then
    printf '\nFor the Zsh update function, set:\n  export NIXOS_CONFIG_DIR=%q\n' "$machine_dir"
  fi
}

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  main "$@"
fi
