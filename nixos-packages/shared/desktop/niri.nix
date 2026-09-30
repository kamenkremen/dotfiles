{pkgs, inputs, ...}: {
    programs.niri.enable = true;
    programs.niri.package = pkgs.niri;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
