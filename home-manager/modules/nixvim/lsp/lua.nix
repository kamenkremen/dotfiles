{pkgs, ...}:
{
programs.nixvim = {
    plugins.lsp.servers = {
      lua_ls.enable = true;
      nil_ls.enable = true;
    };
};
}
