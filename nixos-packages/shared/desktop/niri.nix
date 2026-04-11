{pkgs, inputs, ...}: {
    programs.niri.enable = true;
    programs.niri.package = pkgs.niri;
}
