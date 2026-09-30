{pkgs, ...}: {
  imports = [./common.nix];
  home.packages = with pkgs; [
    vesktop
    discord
    davinci-resolve
    prismlauncher
    lunar-client
  ];
}
