{pkgs, ...}: 
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
  };
}
