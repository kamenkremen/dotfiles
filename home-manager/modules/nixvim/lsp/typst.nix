{pkgs, ...}:
{
programs.nixvim = {
    plugins.lsp.servers.tinymist = {
        enable = true;
        settings.exportPdf = "onType";
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
