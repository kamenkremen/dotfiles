{
  imports = [
    ./hardware-configuration.nix
    
    ./docker.nix
    ./desktop
    ./services
    ./system
    ./programs
    ./stylix.nix
  ];

  system.stateVersion = "24.11";
}
