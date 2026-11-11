{inputs}: {
  hostName,
  username,
  hardware,
  stateVersion,
  homeStateVersion ? stateVersion,
  modules ? [],
  homeModules ? [],
}:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {inherit inputs;};
  modules =
    [
      inputs.stylix.nixosModules.stylix
      inputs.home-manager.nixosModules.home-manager
      inputs.niri.nixosModules.niri
      ../nixos-packages/shared
      ({
        pkgs,
        lib,
        ...
      }: {
        nixpkgs.config.allowUnfree = lib.mkDefault true;
        networking.hostName = hostName;
        system.stateVersion = stateVersion;

        users.users.${username} = {
          isNormalUser = true;
          description = lib.mkDefault username;
          extraGroups = ["networkmanager" "wheel"];
          shell = pkgs.zsh;
        };

        home-manager = {
          useGlobalPkgs = true;
          extraSpecialArgs = {inherit inputs;};
          backupFileExtension = lib.mkDefault "backup";
          users.${username} = {
            imports = [../home-manager] ++ homeModules;
            home.stateVersion = homeStateVersion;
          };
        };
      })
    ]
    ++ modules
    ++ [hardware];
}
