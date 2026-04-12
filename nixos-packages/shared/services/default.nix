{
  imports = [
    ./bluetooth.nix
    ./pipewire.nix
    ./postgres.nix
    ./flatpak.nix
    ./upower.nix
    ./v2raya.nix
  ];
  programs.nix-ld.enable = true;
}
