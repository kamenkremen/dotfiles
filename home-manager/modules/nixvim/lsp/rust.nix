{pkgs, ...}:
{
programs.nixvim = {
    plugins.lsp.servers.rust_analyzer = {
        enable = true;
        installCargo = true;
        installRustc = true;
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
                name = "buffer";
            }
            {
                name = "path";
            }
            {
                name = "crates";
            }
            { name = "vim-dadbod-completion"; }
                ];
      };
};

}
