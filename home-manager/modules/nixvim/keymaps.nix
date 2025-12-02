{...}:
{
programs.nixvim = {
    globals.mapleader = " ";
    keymaps = [
    { key = "<leader>rs"; action = ":!g++ -O2 -std=c++23 -Wall main.cpp -o solution && ./solution < input.in > output.out<CR>"; options.desc = "Run solution"; }
    {
      key = "<leader>oi";
      action = ":edit input.in<CR>";
      options.desc = "Open input";
    }
    {
      key = "<leader>oo";
      action = ":edit output.out<CR>";
      options.desc = "Open output";
    }
    {
      key = "<leader>om";
      action = ":edit main.cpp<CR>";
      options.desc = "Open main.cpp";
    }
  ];
  opts.laststatus = 3;
  globals.statusline = "%f %= %{getcwd()}";
};
}
