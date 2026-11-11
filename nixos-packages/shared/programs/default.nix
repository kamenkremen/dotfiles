{
  imports = [
    ./zsh.nix
  ];
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.throne.enable = true;
  programs.throne.tunMode.enable = true;
}
