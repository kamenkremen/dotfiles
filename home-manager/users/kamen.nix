{ pkgs, ... }:
{
  imports = [ ./common.nix ];
  home.packages = with pkgs; [
     vesktop discord revolt-desktop
     davinci-resolve prismlauncher lunar-client 
  ];
}
