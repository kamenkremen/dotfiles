{ pkgs, ... }:
{
programs.zsh = {
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;

  shellAliases = {
    ll = "ls -l";
    expath = "export PATH=$(pwd):$PATH";
  };
  history.size = 10000;
  # I HATE GUI POLKIT
  initContent = ''
      unset SSH_ASKPASS
      update() {
        local flake_dir="$HOME/dotfiles"
        local target="''${1:-$(hostname)}"
        echo "Rebuilding NixOS for host: $target"
        sudo nixos-rebuild switch --flake "$flake_dir#$target"
      }
  '';
};
}
