{dotfiles}: let
  args = {
    hostName = "portable-test";
    username = "test-user";
    stateVersion = "24.11";
    hardware = {
      nixpkgs.hostPlatform = "x86_64-linux";
      fileSystems."/" = {
        device = "/dev/disk/by-label/test-root";
        fsType = "ext4";
      };
      fileSystems."/boot" = {
        device = "/dev/disk/by-label/test-boot";
        fsType = "vfat";
      };
    };
    modules = [
      ({
        pkgs,
        lib,
        ...
      }: {
        users.users.test-user.home = "/srv/test-user";
        environment.systemPackages = [pkgs.hello];
        services.postgresql.enable = lib.mkForce false;
      })
    ];
    homeModules = [({pkgs, ...}: {home.packages = [pkgs.figlet];})];
  };
  machine = dotfiles.lib.mkHost args;
  newerHome = dotfiles.lib.mkHost (args // {homeStateVersion = "26.05";});
  c = machine.config;
  h = c.home-manager.users.test-user;
  names = packages: map (p: p.pname or p.name) packages;
  result = {
    separateHomeVersion =
      newerHome.config.home-manager.users.test-user.home.stateVersion
      == "26.05"
      && newerHome.config.system.stateVersion == "24.11";
    stableHyprlandFormat = newerHome.config.home-manager.users.test-user.wayland.windowManager.hyprland.configType == "hyprlang";
    hostName = c.networking.hostName == "portable-test";
    user = h.home.username == "test-user" && h.home.homeDirectory == "/srv/test-user";
    stateVersions = c.system.stateVersion == "24.11" && h.home.stateVersion == "24.11";
    systemExtension = builtins.elem "hello" (names c.environment.systemPackages);
    homeExtension = builtins.elem "figlet" (names h.home.packages);
    commonPackages = builtins.elem "firefox" (names h.home.packages);
    override = !c.services.postgresql.enable;
    portablePaths =
      h.programs.noctalia.settings.shell.avatar_path
      == "/srv/test-user/.face"
      && h.programs.noctalia.settings.wallpaper.directory == "/srv/test-user/Pictures/Wallpapers";
    noMachineDisplay = !(h.programs.niri.settings.outputs ? "eDP-1");
    assertions = builtins.all (a: a.assertion) c.assertions;
  };
in
  assert builtins.all (x: x) (builtins.attrValues result); result
