{pkgs, ...}: {
  imports = [
    ./docker.nix
    ./stylix.nix
    ./services
    ./programs
    ./desktop
  ];
  system.stateVersion = "24.11";
}
