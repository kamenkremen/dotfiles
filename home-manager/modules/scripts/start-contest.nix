{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (pkgs.writeScriptBin "start-contest" ''
      #!/usr/bin/env sh
      set -e
      CONTEST_NAME=''${1:-default}
      CONTEST_DIR="$HOME/contests/$CONTEST_NAME"

      mkdir -p "$CONTEST_DIR"
      if [ ! -f "$CONTEST_DIR/main.cpp" ]; then
        cat > "$CONTEST_DIR/main.cpp" <<'EOF'
#include <bits/stdc++.h>
using namespace std;

typedef long long ll;
typedef long double ld;

ll mod = 1e9 + 7;

void solve() {
}

int main() {
    int t; cin >> t;
    while (t--) solve();
    return 0;
}
EOF
      fi
      touch "$CONTEST_DIR/main.cpp" "$CONTEST_DIR/input.in" "$CONTEST_DIR/output.out"
      cd "$CONTEST_DIR"
      nvim \
        -c "edit main.cpp" \
        -c "vsplit input.in" \
        -c "split output.out" \
        -c "wincmd h" \
        -c "vertical resize 50%" \
        -c "wincmd l" \
        -c "resize 50%" \
        -c "wincmd j"
    '')
    ];
}
