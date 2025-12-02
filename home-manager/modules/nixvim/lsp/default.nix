{...}:
{
imports = [
  ./cpp.nix
  ./java.nix
  ./rust.nix
  ./nix.nix
  ./typst.nix
  ./lua.nix
];
programs.nixvim = {
    enable = true; 
    plugins.lsp = {
      enable = true;
      capabilities = "require('cmp_nvim_lsp').default_capabilities()";

      keymaps = {
          silent = true;
          diagnostic = {
              "<space>E" = "open_float";
              "[" = "goto_prev";
              "]" = "goto_next";
              "<space>do" = "setloclist";
          };
          lspBuf = {
              K = "hover";
              gd = "definition";
              gD = "references";
              gt = "type_definition";
              gi = "implementation";
              "<space>cr" = {
                  action = "rename";
                  desc = "Rename";
              };
          };
      };

    };
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
      snippet = {
        expand = ''function(args) require("luasnip").lsp_expand(args.body) end'';
      };

        performance = {
          debounce = 60;
          fetchingTimeout = 200;
          maxViewEntries = 10;
        };
        mapping = {
          "<C-y>" = "cmp.mapping.confirm({ select = true })";
          "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}), {'i', 's'})";
          "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}), {'i', 's'})";
          };
       };
    };

    plugins.cmp-nvim-lsp.enable = true;
    plugins.cmp-buffer.enable = true;
    plugins.cmp-path.enable = true;
    plugins.cmp-cmdline.enable = true;

    plugins.luasnip.enable = true;
    plugins.friendly-snippets.enable = true;

    opts.completeopt = "menu,menuone,noselect";
  };
}
