{pkgs, ...}: {
  #boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # nix
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # locale
  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  fonts.enableDefaultPackages = true;
  # networking
  networking.hostName = "nixsos";
  networking.networkmanager.enable = true;

  # users
  users.users.kamen = {
    isNormalUser = true;
    description = "kamen";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

  # fonts
  fonts.packages = with pkgs; [
    dejavu_fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-sans
    fira-math
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    proggyfonts
  ];

  environment.systemPackages = [pkgs.claude-code];

  # swap file
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024; # 8 GB
    }
  ];
}
