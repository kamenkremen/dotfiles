{
  description = "NixOS config for nixsos with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 
  };

  outputs = { self, nixpkgs, home-manager, nixvim, stylix, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.nixsos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
	  stylix.nixosModules.stylix
          { nixpkgs.config.allowUnfree = true; }

          ./nixos-packages


          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            #home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit nixvim; };
            home-manager.users.kamen = import ./home-manager/home.nix;
	    home-manager.backupFileExtension = "backup"; 
          }
        ];
      };
    };
}
