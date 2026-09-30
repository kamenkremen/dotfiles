{
  description = "NixOS config for nixsos with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
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

    nix-claude-code.url = "github:ryoppippi/nix-claude-code";

    codex-desktop-linux.url = "github:ilysenko/codex-desktop-linux";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    noctalia,
    niri,
    nvf,
    stylix,
    nix-claude-code,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      nixsos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};

        modules = [
          {nixpkgs.overlays = [nix-claude-code.overlays.default];}
          inputs.codex-desktop-linux.nixosModules.default
          {programs.codexDesktopLinux.enable = true;}
          stylix.nixosModules.stylix
          {nixpkgs.config.allowUnfree = true;}
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = {inherit inputs nvf nixpkgs-stable noctalia;};
            home-manager.users.kamen = import ./home-manager/users/kamen.nix;
            home-manager.backupFileExtension = "backup";
          }
          niri.nixosModules.niri
          ./nixos-packages/hosts/nixsos
          ./nixos-packages/shared
        ];
      };
      thinkpad = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};

        modules = [
          stylix.nixosModules.stylix
          {nixpkgs.config.allowUnfree = true;}
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = {inherit inputs nvf nixpkgs-stable noctalia;};
            home-manager.users.ivanz = import ./home-manager/users/ivanz.nix;
            home-manager.backupFileExtension = "backup";
          }
          niri.nixosModules.niri
          ./nixos-packages/hosts/thinkpad
          ./nixos-packages/shared
        ];
      };

    };
  };
}
