{
  description = "NixOS config for nixsos with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
        url = "github:nix-community/nixvim";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
        url = "github:sodiboo/niri-flake";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, nixvim, stylix, noctalia, niri, ... } @inputs:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        nixsos = nixpkgs.lib.nixosSystem {
            inherit system;
	        specialArgs = { inherit inputs; };

            modules = [
	            stylix.nixosModules.stylix
                { nixpkgs.config.allowUnfree = true; }
                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.extraSpecialArgs = { inherit inputs nixvim nixpkgs-stable noctalia; };
                    home-manager.users.kamen = import ./home-manager/home.nix;
	                home-manager.backupFileExtension = "backup"; 
                }
                niri.nixosModules.niri
                ./nixos-packages/hosts/nixsos
                ./nixos-packages/shared
            ];
          };
      };
    };
}
