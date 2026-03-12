{ pkgs, username, ... }: {
  home = {
    username      = username;
    homeDirectory = "/home/${username}";
    stateVersion  = "24.11";
  };

  programs.home-manager.enable = true;
  xdg.enable = true;

  # ── GTK / Qt / Cursor ───────────────────────────────────────────────────
  gtk = {
    enable    = true;
    theme     = { name = "adw-gtk3-dark"; package = pkgs.adw-gtk3; };
    iconTheme = { name = "Papirus-Dark"; package = pkgs.papirus-icon-theme; };
    cursorTheme = {
      name    = "BreezeX-RosePine-Linux";
      size    = 24;
      package = pkgs.rose-pine-cursor;
    };
    gtk3.extraConfig."gtk-application-prefer-dark-theme" = true;
    gtk4.extraConfig."gtk-application-prefer-dark-theme" = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "Fusion";
  };

  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris        = [ "qemu:///system" ];
    };
  };

  home.pointerCursor = {
    name    = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
    size    = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    XCURSOR_THEME  = "BreezeX-RosePine-Linux";
    XCURSOR_SIZE   = "24";
    NIXOS_OZONE_WL = "1";
    ICON_THEME     = "Papirus";
    QS_ICON_THEME  = "Papirus";
  };

  xdg.configFile = {
    "gtk-3.0/settings.ini".force = true;
    "gtk-4.0/settings.ini".force = true;
    "gtk-4.0/gtk.css".force      = true;
  };

  # ── Terminal ─────────────────────────────────────────────────────────────
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window = {
        dynamic_padding = true;
        decorations = "full";
        opacity = 0.9;
        padding = { x = 6; y = 6; };
        decorations_theme_variant = "Dark";
        dimensions = { columns = 100; lines = 30; };
      };
      scrolling = { history = 10000; multiplier = 3; };
      font = {
        size = 12.0;
        normal      = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
        bold        = { family = "JetBrainsMono Nerd Font"; style = "Bold"; };
        italic      = { family = "JetBrainsMono Nerd Font"; style = "Italic"; };
        bold_italic = { family = "JetBrainsMono Nerd Font"; style = "Bold Italic"; };
      };
      colors.draw_bold_text_with_bright_colors = true;
      selection = {
        semantic_escape_chars = '',│`|:"' ()[]{}<>\t'';
        save_to_clipboard = true;
      };
      cursor = {
        style = "Underline";
        unfocused_hollow = true;
        thickness = 0.15;
      };
      mouse.hide_when_typing = true;
    };
  };

  # ── Neovim ──────────────────────────────────────────────────────────────
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    viAlias       = true;
    vimAlias      = true;
  };

  # ── Git ──────────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    settings = {
      user.name  = "Robin Smith";
      user.email = "your@email.com";    # !! change me !!
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };

  # ── btop ─────────────────────────────────────────────────────────────────
  programs.btop = {
    enable = true;
    settings = {
      theme_background = true;
      truecolor        = true;
      rounded_corners  = true;
      show_battery     = true;
      vim_keys         = false;
      update_ms        = 2000;
    };
  };

  # ── Config file deployment (compositor-agnostic) ────────────────────────
  xdg.configFile = {
    "nvim/init.lua".source                  = ../config/nvim/init.lua;
    "nvim/stylua.toml".source               = ../config/nvim/stylua.toml;
    "nvim/.neoconf.json".source             = ../config/nvim/.neoconf.json;
    "nvim/lua/config/lazy.lua".source       = ../config/nvim/lua/config/lazy.lua;
    "nvim/lua/config/options.lua".source    = ../config/nvim/lua/config/options.lua;
    "nvim/lua/config/keymaps.lua".source    = ../config/nvim/lua/config/keymaps.lua;
    "nvim/lua/config/autocmds.lua".source   = ../config/nvim/lua/config/autocmds.lua;
    "nvim/lua/plugins/base16.lua".source    = ../config/nvim/lua/plugins/base16.lua;
    "nvim/lua/matugen-template.lua".source  = ../config/nvim/lua/matugen-template.lua;
    "noctalia/user-templates.toml".source   = ../config/noctalia/user-templates.toml;
    "fastfetch/config.jsonc".source         = ../config/fastfetch/config.jsonc;
  };

  # ── User packages ───────────────────────────────────────────────────────
  home.packages = with pkgs; [
    fastfetch
    libsForQt5.qt5ct
  ];
}
