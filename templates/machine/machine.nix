{
  hostName = "my-machine";
  username = "my-user";
  hardware = ./hardware-configuration.nix;

  # Copy system.stateVersion from the existing NixOS configuration.
  # Do not change it merely because NixOS or the dotfiles were updated.
  # Set homeStateVersion separately if an existing Home Manager uses another version.
  stateVersion = throw "Set stateVersion to the value from your existing NixOS configuration.";

  modules = [./system.nix];
  homeModules = [./home.nix];
}
