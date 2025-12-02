{pkgs, ...}:
{
programs.nixvim = {
    plugins.lsp.servers.jdtls = {
      enable = true;
      package = pkgs.jdt-language-server;
      settings = {
        compiler = {
          source = "23";
          target = "23";
        };
      };
    };

    plugins.cmp.filetype.java = {
        sources = [
            { name = "nvim_lsp"; }
            { name = "buffer"; option.get_bufnrs.__raw = "vim.api.nvim_list_bufs"; 
            keywordLength = 2; }
            { name = "path";  keywordLength = 2; }
        ];
    }; 
};
}
