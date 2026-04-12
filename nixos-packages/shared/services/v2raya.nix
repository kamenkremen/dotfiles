{pkgs, ...}: {
  services.v2raya.enable = true;
  services.v2raya.cliPackage = pkgs.xray;
}
