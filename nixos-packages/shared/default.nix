{pkgs, ...}: {
  imports = [
    ./docker.nix
    ./stylix.nix
    ./services
    ./programs
    ./desktop
  ];
  nixpkgs.overlays = [
    (import ../../overlays/codex.nix)
  ];
  system.stateVersion = "24.11";
}
