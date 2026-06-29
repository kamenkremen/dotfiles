{noctalia, ...}: {
  imports = [
    noctalia.homeModules.default
  ];
  programs.noctalia = {
    enable = true;
    settings = ./settings.toml;
  };
}
