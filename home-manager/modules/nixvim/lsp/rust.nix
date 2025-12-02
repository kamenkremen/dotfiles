{pkgs, ...}:
{
programs.nixvim = {
    plugins.lsp.servers.rust-analyzer = {
        enable = true;
        settings = {
        "rust-analyzer" = {
          cargo = {
            allFeatures = true;
            buildScripts.enable = true;
          };
          checkOnSave = {
            enable = true;
            command = "clippy";
          };
          procMacro.enable = true;

          diagnostics.enable = true;

          inlayHints = {
            # минимально полезные хинты; можно расширить по вкусу
            lifetimeElisionHints = { enable = "always"; useParameterNames = true; };
            parameterHints = { enable = true; };
            typeHints = { enable = true; };
          };
        };
      };
    };

    plugins.cmp.filetype.rust = {
        sources = [
            { name = "git"; }
            { name = "nvim_lsp"; }
            {
                name = "buffer"; # text within current buffer
            }
            {
                name = "path"; # file system paths
            }
            {
                name = "crates";
            }
            { name = "vim-dadbod-completion"; }
                ];
      };
};

}
