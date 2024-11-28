{
  programs.nixvim.plugins.todo-comments = {
    enable = true;
    settings = {
      keywords = {
        FIXME = {
          alt = [
            "FIX"
            "BUG"
          ];
          color = "error";
          icon = " ";
        };
        HACK = {
          color = "warning";
          icon = " ";
        };
        TODO = {
          color = "info";
          icon = " ";
        };
      };
      signs = true;
    };
  };
}
