{ config, inputs, lib, pkgs, ... }:
let pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in {
    programs.ghostty = {
        settings.gtk-single-instance = true;
        package = pkgs-stable.ghostty;
        enable = true;
        systemd.enable = true;
        enableZshIntegration = true;

        settings = {
            custom-shader = [
                "${config.xdg.configHome}/ghostty/shaders/cursor_sweep.glsl"
                "${config.xdg.configHome}/ghostty/shaders/ripple_cursor.glsl"
            ];
            custom-shader-animation = true;
        };
    };
    xdg.configFile = lib.mkMerge [{ 
        "ghostty/shaders/ripple_cursor.glsl".source = ./ripple_cursor.glsl;
        "ghostty/shaders/cursor_sweep.glsl".source = ./cursor_sweep.glsl;
    }];
}
