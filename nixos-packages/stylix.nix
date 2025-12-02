{pkgs, ...}: 
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
    #image = ./wallpapers/kislev.jpg;
    #cursor = {
    #  package = pkgs.bibata-cursors;
    #  name = "Bibata-Modern-Ice";
    #  size = 1;
    #  };
  };
}
