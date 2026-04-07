{ pkgs, ... }:
{
programs.zsh = {
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;

  shellAliases = {
    ll = "ls -l";
    update = "sudo nixos-rebuild switch";
    expath = "export PATH=$(pwd):$PATH";
  };
  history.size = 10000;
};
}
