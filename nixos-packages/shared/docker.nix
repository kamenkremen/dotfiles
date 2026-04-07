{pkgs, ...}: 
{
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose
    home-manager
  ];
}
