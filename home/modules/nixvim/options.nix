{
  programs.nixvim = {
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    opts = {
      updatetime = 100;

      relativenumber = true;
      number = true;
      hidden = true;

      swapfile = false;
      undofile = true;

      signcolumn = "yes";
      scrolloff = 4;

      termguicolors = true;
      spell = true;
      tabstop = 4;
      autoindent = true;
    };
  };
}
