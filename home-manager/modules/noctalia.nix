{noctalia, pkgs, lib, ...}:
{
    imports = [
        noctalia.homeModules.default
    ];
    programs.noctalia-shell.enable = true;
}
