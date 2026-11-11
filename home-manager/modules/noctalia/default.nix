{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];
  programs.noctalia = {
    enable = true;
    settings =
      lib.recursiveUpdate
      (builtins.fromTOML (builtins.readFile ./settings.toml))
      {
        shell.avatar_path = "${config.home.homeDirectory}/.face";
        wallpaper = {
          directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
          default.path = "${../wallpapers/gruvbible.png}";
          last.path = "${../wallpapers/gruvbible.png}";
        };
      };
  };
}
