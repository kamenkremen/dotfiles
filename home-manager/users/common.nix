{
  config,
  pkgs,
  inputs,
  lib,
  nvf,
  stylix,
  nixpkgs-stable,
  ...
}: let
  pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in {
  disabledModules = ["programs/niri.nix"];
  imports = [
    nvf.homeManagerModules.nvf
    ../modules
  ];

  home.stateVersion = "24.11";

  fonts.fontconfig.enable = true;

  programs.zsh.enable = true;
  #programs.throne.enable = true;
  #programs.throne.tunMode.enable = true;

  programs.btop.enable = true;
  programs.zathura.enable = true;

  home.packages = with pkgs; [
    # dev / utils
    opencode
    spotify
    xwayland-satellite
    hyprpolkitagent
    git
    wget
    fastfetch
    unzip
    cmake
    gcc #rustc cargo rustfmt clippy rust-analyzer
    #rust.packages.stable.rustPlatform.rustLibSrc
    maven
    nodejs
    qemu
    dpkg
    wireguard-tools
    protonvpn-gui
    rpm
    fakeroot
    ripgrep
    reaper
    fd
    dotnetCorePackages.dotnet_9.sdk
    dotnetCorePackages.dotnet_9.runtime
    dotnetCorePackages.dotnet_9.aspnetcore
    # gui / apps
    firefox
    codex
    obs-studio
    telegram-desktop
    vesktop
    discord
    revolt-desktop
    kdePackages.okular
    zathura
    libreoffice
    gimp
    google-chrome
    openvpn
    brightnessctl
    crosspipe
    pavucontrol
    pulseaudio
    davinci-resolve
    qt6.qtimageformats
    qt6.qtwayland
    grim
    slurp
    wf-recorder
    tesseract
    zbar
    bubblewrap
    obsidian

    # MINECRAFT
    prismlauncher
    lunar-client

    heroic

    # wayland / desktop
    wl-clipboard
    awww
    hyprshot
    libnotify
    kitty
    networkmanagerapplet
    gpu-screen-recorder

    # printing/latex/typst
    texlive.combined.scheme-full
    typst
    tinymist

    alsa-lib.dev

    wineWow64Packages.stable
    winetricks

    postgresql
    # lsp/tools
    lua-language-server
    clang-tools
    jdt-language-server

    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack

    noto-fonts-color-emoji
    noto-fonts-cjk-sans

    update-resolv-conf

    xdg-desktop-portal-gtk
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };
}
