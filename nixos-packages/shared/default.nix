{
  imports = [
    ./base.nix
    ./docker.nix
    ./stylix.nix
    ./services
    ./programs
    ./desktop
  ];
  nixpkgs.overlays = [
    (import ../../overlays/codex.nix)
  ];
}
