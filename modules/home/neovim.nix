{ pkgs, ... }: {
  programs.nixvim = {
    enable        = true;
    defaultEditor = true;
    viAlias       = true;
    vimAlias      = true;

    # ── lazy.nvim + LazyVim ────────────────────────────────────────────────
    # LazyVim is pulled from nixpkgs vimPlugins and bootstrapped via lazy.nvim.
    # Add extras inside `opts.spec`; they resolve against the LazyVim runtime
    # path that is already on the runtimepath from the `pkg` entry.
    plugins.lazy = {
      enable = true;
      plugins = [
        {
          pkg    = pkgs.vimPlugins.LazyVim;
          import = "lazyvim.plugins";
          opts = {
            spec = [
              { import = "lazyvim.plugins.extras.lang.typst"; }
              # Uncomment extras as needed:
              # { import = "lazyvim.plugins.extras.lang.typescript"; }
              # { import = "lazyvim.plugins.extras.lang.python"; }
              # { import = "lazyvim.plugins.extras.lang.rust"; }
              # { import = "lazyvim.plugins.extras.editor.telescope"; }
            ];
          };
        }
      ];
    };

    # ── External tools ─────────────────────────────────────────────────────
    # These are placed on $PATH inside Neovim's environment.
    # LazyVim / conform.nvim / nvim-lspconfig pick them up automatically.
    extraPackages = with pkgs; [
      # Typst
      tinymist    # Typst LSP (replaces typst-lsp)
      typstyle    # Typst formatter

      # LazyVim hard dependencies
      lazygit     # Git UI  — <leader>gg
      ripgrep     # Telescope live_grep
      fd          # Telescope file finder

      # Formatters
      stylua      # Lua
      prettierd   # JS / TS / JSON / CSS / HTML / Markdown (bundles prettier)
      shfmt       # Shell
      shellcheck  # Shell linter
    ];
  };
}
