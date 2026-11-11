{
  description = "My NixOS machine";

  inputs.dotfiles.url = "github:kamenkremen/dotfiles?ref=reusable-config";

  outputs = {dotfiles, ...}: {
    nixosConfigurations.local = dotfiles.lib.mkHost (import ./machine.nix);
  };
}
