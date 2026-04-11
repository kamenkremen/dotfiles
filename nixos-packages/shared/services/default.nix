{ pkgs, ... }:
{
  imports = [
    ./bluetooth.nix
    ./pipewire.nix
    ./postgres.nix
    ./flatpak.nix
  ];
  programs.nix-ld.enable = true;
}
