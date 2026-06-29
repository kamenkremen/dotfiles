{
  imports = [
    ./bluetooth.nix
    ./pipewire.nix
    ./postgres.nix
    ./flatpak.nix
    ./upower.nix
    ./printer.nix
  ];
  programs.nix-ld.enable = true;
  services.resolved.enable = true;
  networking.firewall.checkReversePath = "loose";
}
