{...}:
{
  programs.nixvim = {
    diagnostics = {
        enable = true;
        virtualText = {
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
        updateInInsert = false;
        severitySort = true;
    };
  };
}
