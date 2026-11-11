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
        local flake_dir="''${NIXOS_CONFIG_DIR:-$HOME/nixos-configs/$(hostname)}"
        if [[ ! -f "$flake_dir/flake.nix" ]]; then
          print -u2 "No flake.nix in $flake_dir; set NIXOS_CONFIG_DIR to your machine configuration."
          return 1
        fi
        echo "Rebuilding NixOS from: $flake_dir#local"
        sudo nixos-rebuild switch --flake "$flake_dir#local" "$@"
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
