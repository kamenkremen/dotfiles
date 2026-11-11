{
  description = "Reusable NixOS desktop configuration with Home Manager";

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
  };

  outputs = inputs: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {inherit system;};
    initMachine = pkgs.writeShellApplication {
      name = "init-machine";
      runtimeInputs = [pkgs.coreutils pkgs.gnugrep pkgs.nix];
      text =
        ''
          readonly template_dir=${./templates/machine}
        ''
        + builtins.readFile ./scripts/init-machine.sh;
    };
  in {
    lib.mkHost = import ./lib/mk-host.nix {inherit inputs;};
    packages.${system}.init-machine = initMachine;
    apps.${system}.init-machine = {
      type = "app";
      program = "${initMachine}/bin/init-machine";
      meta.description = "Prepare a standalone configuration for this NixOS machine";
    };
    templates.machine = {
      path = ./templates/machine;
      description = "A standalone NixOS machine using these dotfiles";
    };
  };
}
