{ pkgs, ... }:
{
programs.nixvim.plugins.telescope = {
    enable = true;

    settings.defaults = {
      file_ignore_patterns = [ "^.git/" "^node_modules/" ];
      layout_config.horizontal.preview_width = 0.5;
    };

    extensions = {
      fzf-native.enable = true;
      live-grep-args.enable = true;
      ui-select.enable = true;
      file-browser.enable = true;
      undo.enable = true;
    };
    keymaps = {
      "<leader>ff" = "find_files";
      "<leader>fg" = "live_grep";
      "<leader>fa" = {
        action = "live_grep_args";
        options.desc = "Live Grep with Args";
      };
      "<leader>fb" = "buffers";
      "<leader>fh" = "help_tags";
      "<leader>fd" = "diagnostics";
      "<leader>fu" = "undo";
      };
  };
}
