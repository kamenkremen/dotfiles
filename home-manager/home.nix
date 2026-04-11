{ config, pkgs, inputs, lib, nixvim, stylix, nixpkgs-stable, ... }:
let
  pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  disabledModules = [ "programs/niri.nix" ];
  imports = [
    
    nixvim.homeModules.nixvim
    ./modules
  ];

  home.username = "kamen";
  home.homeDirectory = "/home/kamen";
  home.stateVersion = "24.11";

  fonts.fontconfig.enable = true;

  programs.zsh.enable = true;

  #programs.waybar.enable = true;
  services.dunst.enable = true; 

  programs.wofi.enable = true;
  programs.btop.enable = true;
  programs.zathura.enable = true;
  gtk.gtk4.theme = null;

  home.packages = with pkgs; [
    # dev / utils
    opencode spotify xwayland-satellite hyprpolkitagent
    git wget fastfetch unzip cmake
    gcc rustc cargo rustfmt clippy rust-analyzer
    rust.packages.stable.rustPlatform.rustLibSrc
    maven nodejs qemu 
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
    openvpn brightnessctl crosspipe pavucontrol
    davinci-resolve qt6.qtimageformats
    qt6.qtwayland grim slurp wf-recorder tesseract zbar

    # MINECRAFT
    prismlauncher lunar-client

    # wayland / desktop
    wl-clipboard awww hyprshot libnotify
    kitty networkmanagerapplet gpu-screen-recorder

    # printing/latex/typst
    texlive.combined.scheme-full typst tinymist

    alsa-lib.dev

    wineWow64Packages.stable winetricks

    postgresql

    # lsp/tools
    lua-language-server clang-tools jdt-language-server

    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack

    noto-fonts-color-emoji
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
