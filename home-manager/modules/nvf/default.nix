{
  pkgs,
  lib,
  ...
}: {
  home.file.".clang-format".text = ''
    BasedOnStyle: LLVM
    IndentWidth: 4
    TabWidth: 4
    UseTab: Never
  '';
  programs.nvf = {
    enable = true;

    settings.vim = {
      viAlias = true;
      vimAlias = true;

      options = {
        number = true;
        relativenumber = true;
        tabstop = 4;
        softtabstop = 4;
        shiftwidth = 4;
        expandtab = true;
        hlsearch = false;
        incsearch = true;
        undofile = true;
        termguicolors = true;
        scrolloff = 8;
        signcolumn = "yes";
        updatetime = 50;
        colorcolumn = "81";
      };

      clipboard = {
        enable = true;
        providers.wl-copy.enable = true;
        registers = "unnamed,unnamedplus";
      };

      keymaps = [
        {
          key = "<leader>rs";
          mode = "n";
          action = ":!g++ -O2 -std=c++23 -Wall main.cpp -o solution && ./solution < input.in > output.out<CR>";
        }
        {
          key = "<leader>oi";
          mode = "n";
          action = ":edit input.in<CR>";
        }
        {
          key = "<leader>oo";
          mode = "n";
          action = ":edit output.out<CR>";
        }
        {
          key = "<leader>om";
          mode = "n";
          action = ":edit main.cpp<CR>";
        }
      ];

      luaConfigRC.solution-check = ''
        if vim.fn.filereadable("solution") == 0 and vim.fn.filereadable("main.cpp") == 1 and vim.fn.filereadable("output.out") == 1 and vim.fn.filereadable("input.in") == 1 then vim.cmd("!touch solution && chmod +x solution") end
      '';

      theme = {
        enable = true;
        name = lib.mkForce "gruvbox";
        style = "dark";
      };

      statusline.lualine = {
        enable = true;
        globalStatus = true;
        ignoreFocus = ["NvimTree" "neo-tree"];
      };

      treesitter = {
        enable = true;
      };

      autopairs.nvim-autopairs = {
        enable = true;
      };

      filetree.neo-tree.enable = true;

      navigation.harpoon.enable = true;

      telescope = {
        enable = true;
        setupOpts.defaults = {
          file_ignore_patterns = ["^.git/" "^node_modules/"];
          layout_config.horizontal.preview_width = 0.5;
        };
        extensions = [
          {
            name = "ui-select";
            packages = [pkgs.vimPlugins.telescope-ui-select-nvim];
            setup = {};
          }
          # didn't work for me from the box, don't care enough rn
          #{
          #name = "file-browser";
          #packages = [pkgs.vimPlugins.telescope-file-browser-nvim];
          #setup = {};
          #}
          {
            name = "undo";
            packages = [pkgs.vimPlugins.telescope-undo-nvim];
            setup = {};
          }
        ];
        mappings = {
          findFiles = "<leader>ff";
          liveGrep = "<leader>fg";
          buffers = "<leader>fb";
          helpTags = "<leader>fh";
          diagnostics = "<leader>fd";
        };
      };

      dashboard.alpha.enable = true;

      git = {
        gitsigns.enable = true;
        vim-fugitive.enable = true;
        neogit.enable = true;
      };

      comments.comment-nvim.enable = true;

      autocomplete = {
        blink-cmp = {
          enable = true;
          friendly-snippets.enable = true;
          sourcePlugins = {
            ripgrep.enable = true;
            emoji.enable = true;
            spell.enable = true;
          };
        };
      };

      snippets.luasnip.enable = true;

      lsp = {
        enable = true;
        formatOnSave = true;
      };

      languages = {
        enableTreesitter = true;
        enableFormat = true;
        enableExtraDiagnostics = true;

        nix = {
          enable = true;
          lsp.enable = true;
        };

        lua = {
          enable = true;
          lsp.enable = true;
        };

        clang = {
          enable = true;
          lsp.enable = true;
        };

        rust = {
          enable = true;
          lsp = {
            enable = true;
          };
        };

        typst = {
          enable = true;
          lsp.enable = true;
        };

        java = {
          enable = true;
          lsp.enable = true;
        };

        go = {
          enable = true;
          lsp.enable = true;
        };

        json = {
          enable = true;
          lsp.enable = true;
        };

        markdown = {
          enable = true;
          lsp.enable = true;
        };

        html = {
          enable = true;
          lsp.enable = true;
        };

        css = {
          enable = true;
          lsp.enable = true;
        };

        bash = {
          enable = true;
          lsp.enable = true;
        };
      };

      diagnostics = {
        enable = true;
        config = {
          virtual_text = {
            enable = true;
            prefix = "●";
            source = true;
            severity = {
              min = "hint";
              max = "error";
            };
          };
          signs = {
            enable = true;
          };
          underline = {
            enable = true;
          };
          update_in_insert = false;
          severitySort = true;
        };
      };
    };
  };
}
