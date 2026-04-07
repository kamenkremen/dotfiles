{stylix, pkgs, ...}:
{
  stylix = {
    targets = {
      alacritty.enable = true;
      ghostty.enable = true;
      vesktop.enable = true;
      dunst.enable = true;
      wofi.enable = true;
      rofi.enable = true;
      firefox = {
        enable = true;
	    profileNames = ["default"];
      };
      noctalia-shell.enable = true;
    };
    image = ./wallpapers/gruvbible.png;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";

  };

}
