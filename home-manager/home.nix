{ config, pkgs, inputs, lib, nixvim, stylix, ... }:
let
  pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  imports = [
    nixvim.homeManagerModules.nixvim
    ./modules
  ];
  
  programs.home-manager.enable = true;
  home.username = "kamen";
  home.homeDirectory = "/home/kamen";
  home.stateVersion = "24.11";

  fonts.fontconfig.enable = true;

  programs.zsh.enable = true;

  programs.waybar.enable = true;
  services.dunst.enable = true;


  programs.wofi.enable = true;
  programs.btop.enable = true;
  programs.zathura.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [
        "swww init"
        "nm-applet --indicator"
        "dunst"
      ];
    };
  };

  home.packages = with pkgs; [
    # dev / utils
    git wget neofetch unzip cmake
    gcc rustc cargo rustfmt clippy rust-analyzer
    pkgs.rust.packages.stable.rustPlatform.rustLibSrc
    maven nodejs yarn-berry yarn2nix node2nix
    dpkg rpm fakeroot ripgrep fd

    # dotnet
    dotnetCorePackages.dotnet_9.sdk
    dotnetCorePackages.dotnet_9.runtime
    dotnetCorePackages.dotnet_9.aspnetcore

    # gui / apps
    firefox vscode obs-studio
    pkgs-stable.telegram-desktop vesktop discord revolt-desktop
    kdePackages.okular zathura libreoffice gimp
    google-chrome 
    openvpn brightnessctl helvum pavucontrol
    davinci-resolve

    # MINECRAFT
    prismlauncher lunar-client

    # wayland / desktop
    wl-clipboard swww hyprshot libnotify
    kitty networkmanagerapplet

    # printing/latex/typst
    texlive.combined.scheme-full typst tinymist

    alsa-lib.dev

    wineWowPackages.stable winetricks

    postgresql

    # lsp/tools
    lua-language-server clang-tools jdt-language-server

    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack

    noto-fonts-emoji
    noto-fonts-cjk-sans
	
    update-resolv-conf

    xdg-desktop-portal-gtk
  ];

  programs.vesktop.enable = true;


  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  }; 
}
