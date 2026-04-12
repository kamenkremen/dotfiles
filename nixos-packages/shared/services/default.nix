{
  imports = [
    ./bluetooth.nix
    ./pipewire.nix
    ./postgres.nix
    ./flatpak.nix
    ./upower.nix
  ];
  programs.nix-ld.enable = true;
}
