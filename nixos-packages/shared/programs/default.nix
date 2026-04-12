{
  imports = [
    ./zsh.nix
  ];
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
}
