{ inputs, ... }: {
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;

    colorschemes.ayu-dark.enable = true;

    opts = {
      number         = true;
      relativenumber = true;
      shiftwidth     = 2;
      tabstop        = 2;
      expandtab      = true;
      termguicolors  = true;
    };

    plugins = {
      lsp = {
        enable = true;
        servers = {
          nixd.enable   = true;
          lua-ls.enable = true;
        };
      };

      lsp-format.enable = true;

      cmp = {
        enable            = true;
        autoEnableSources = true;
      };

      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable   = true;
      cmp-path.enable     = true;
      cmp_luasnip.enable  = true;

      luasnip.enable   = true;
      telescope.enable = true;

      treesitter = {
        enable  = true;
        indent  = true;
        folding = true;
      };

      which-key.enable = true;
      oil.enable       = true;
      gitsigns.enable  = true;
    };
  };
}