{ pkgs, username, ... }: {
  imports = [
    ./shell.nix
    ./neovim.nix
    ./apps.nix
    ./development.nix
  ];

  home = {
    username      = username;
    homeDirectory = "/home/${username}";
    # Do NOT change stateVersion after first install
    stateVersion  = "24.11";
  };

  programs.home-manager.enable = true;

  # XDG base dirs + user directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # GTK theming
  gtk = {
    enable = true;
    theme = {
      name    = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name    = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name    = "Adwaita";
      size    = 24;
      package = pkgs.adwaita-icon-theme;
    };
  };

  # Prefer dark mode in apps that respect this
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # Noctalia shell — home-manager configuration
  programs.noctalia-shell = {
    enable = true;
    # Start Noctalia as a systemd user service after graphical-session.target
    systemd.enable = true;
    settings = {
      # General appearance
      general = {
        blur   = true;
        shadow = true;
        # Radius applied to panels and popups
        radius = 12;
      };
      # Top bar
      bar = {
        position = "top";
        # "compact" | "normal" | "expanded"
        density  = "normal";
      };
      # App launcher / search
      launcher = {
        terminal = "alacritty";
        # Show clipboard history in launcher
        clipboard.enable = true;
      };
      # Notifications
      notifications = {
        # Timeout in ms per urgency level
        timeout.low      = 5000;
        timeout.normal   = 8000;
        timeout.critical = 0;  # persistent
        markdown         = true;
      };
    };
  };

  # Niri window manager config
  home.file.".config/niri/config.kdl".source = ../../config/niri/config.kdl;
}
