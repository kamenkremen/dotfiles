{nixvim, pkgs, lib, ...}:
{
imports = [
  ./lsp
  ./diagnostics.nix
  ./keymaps.nix
];
programs.nixvim = {
    enable = true;

    # because wtf????
    plugins.lsp.servers.dockerls.enable = lib.mkForce false;

    plugins.harpoon.enable = true;
    plugins.neo-tree.enable = true;
 
    opts = {
      number = true;
      relativenumber = true;
      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true ;
      hlsearch = false;
      incsearch = true;
      undofile = true;
      termguicolors = true;
      scrolloff = 8;
      signcolumn = "yes";
      updatetime = 50;
      colorcolumn = "120";
      clipboard = {
          name = "wl-clipboard";
          copy = {
            "+" = "wl-copy --foreground --type text/plain";
            "*" = "wl-copy --foreground --type text/primary";
          };
          paste = {
            "+" = "wl-paste --no-newline";
            "*" = "wl-paste --no-newline --primary";
          };
          cacheEnabled = true;
          providers = {
              wl-copy.enable = true; 
          };
          register = "unnamedplus";
      };
    };

    extraConfigLua = '' -- Автоматическое создание solution при первом запуске
  if vim.fn.filereadable("solution") == 0 and vim.fn.filereadable("main.cpp") == 1 and vim.fn.filereadable("output.out") == 1 and vim.fn.filereadable("input.in") == 1 then vim.cmd("!touch solution && chmod +x solution") end '';

    plugins.typst-preview.enable = true;
    plugins.nvim-autopairs.enable = true;
    plugins.crates-nvim.enable = true;

    /*colorschemes.gruvbox = {
        enable = true;
        settings = {
            diagnostic = {
                virtual_text = true;
                underline = true;
            };
            undercurl = true;
            underline = true;
            bold = true;
        };
    };*/
    colorschemes.tokyonight = {
    	enable = true;
	settings = {
            diagnostic = {
                virtual_text = true;
                underline = true;
            };
            undercurl = true;
            underline = true;
            bold = true;
        };
    };


    plugins.lualine = {
        enable = true;
        sections = {
            lualine_b = [
                "diagnostics"
                "diff"
                "mode"
            ];
        };
    };

    plugins.treesitter = {
        enable = true;

        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            bash
            json
            lua
            markdown
            nix
            toml
            vim
            vimdoc
            rust
            latex
            cpp
            go
        ];

        settings = {
            highlight.enable = true;
        };

        nixvimInjections = true;
    };


  };
}
