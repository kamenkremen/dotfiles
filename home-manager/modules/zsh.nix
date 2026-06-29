{pkgs, ...}: {
  home.packages = [pkgs.any-nix-shell];
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
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
      unset SSH_ASKPASS
      update() {
        local flake_dir="$HOME/dotfiles"
        local target="''${1:-$(hostname)}"
        echo "Rebuilding NixOS for host: $target"
        sudo nixos-rebuild switch --flake "$flake_dir#$target"
      }
    '';
  };
  programs.starship = {
    enable = true;
    settings = {
      format = "$directory$git_branch$nix_shell$character";

      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol$state( \\($name\\))]($style) ";
        style = "bold blue";
        impure_msg = "impure";
        pure_msg = "pure";
        unknown_msg = "flake";
      };
    };
  };
}
