{ pkgs, ... }:
{
    imports = [
        ./docker.nix
        ./stylix.nix
        ./services
        ./programs
        ./desktop
    ];
    system.stateVersion = "24.11";
    programs.clash-verge.enable = true;
    services.v2raya.enable = true;
    services.v2raya.cliPackage = pkgs.xray;
}
