{
  stylix,
  pkgs,
  ...
}: {
  stylix = {
    targets = {
      alacritty.enable = true;
      ghostty.enable = false;
      vesktop.enable = true;
      dunst.enable = true;
      wofi.enable = true;
      rofi.enable = true;
      neovim.enable = false;
      nvf.enable = false;
      firefox = {
        enable = true;
        profileNames = ["default"];
      };
      # i want to configure widgets :^(
      noctalia.enable = false;
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";
  };
}
