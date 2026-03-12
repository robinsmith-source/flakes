{ pkgs, username, ... }: {
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
  xdg.enable = true;

  # ── GTK / Qt / Cursor ───────────────────────────────────────────────────
  gtk = {
    enable = true;
    theme = { name = "adw-gtk3-dark"; package = pkgs.adw-gtk3; };
    iconTheme = { name = "Papirus-Dark"; package = pkgs.papirus-icon-theme; };
    cursorTheme = {
      name = "BreezeX-RosePine-Linux";
      size = 24;
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
      uris = [ "qemu:///system" ];
    };
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      show-hidden-files = true;
      show-delete-permanently = true;
    };
    "org/gnome/nautilus/list-view" = {
      default-zoom-level = "small";
      use-tree-view = true;
    };
    "org/gtk/settings/file-chooser" = {
      sort-directories-first = true;
      show-hidden = true;
    };
  };

  home.pointerCursor = {
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    XCURSOR_THEME = "BreezeX-RosePine-Linux";
    XCURSOR_SIZE = "24";
    NIXOS_OZONE_WL = "1";
    ICON_THEME = "Papirus";
    QS_ICON_THEME = "Papirus";
  };

  xdg.configFile = {
    "gtk-3.0/settings.ini".force = true;
    "gtk-4.0/settings.ini".force = true;
    "gtk-4.0/gtk.css".force = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Robin Schmid";
      user.email = "schmidtrobin02@gmail.com";
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      theme_background = true;
      truecolor = true;
      rounded_corners = true;
      show_battery = true;
      vim_keys = false;
      update_ms = 2000;
    };
  };
}
