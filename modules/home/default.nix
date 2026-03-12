{ pkgs, username, ... }: {
  home = {
    username      = username;
    homeDirectory = "/home/${username}";
    stateVersion  = "24.11";
  };

  programs.home-manager.enable = true;
  xdg.enable = true;

  # ── Niri (niri-flake HM module) ──────────────────────────────────────────
  programs.niri.config = null;

  # ── Noctalia shell ───────────────────────────────────────────────────────
  # Configured entirely through home-manager per:
  #   https://docs.noctalia.dev/getting-started/nixos/
  # The systemd user service starts noctalia — do NOT also spawn it in
  programs.noctalia-shell = {
    enable         = true;
    systemd.enable = true;

    settings = {
      bar = {
        position            = "top";
        barType             = "simple";
        density             = "default";
        displayMode         = "always_visible";
        backgroundOpacity   = 0.93;
        contentPadding      = 2;
        showCapsule         = false;
        capsuleOpacity      = 0.26;
        floating            = false;
        outerCorners        = true;
        marginHorizontal    = 4;
        marginVertical      = 4;
        mouseWheelAction    = "content";
        rightClickAction    = "controlCenter";
        widgets = {
          left = [
            {
              id = "Clock";
              formatHorizontal = "HH:mm ddd, MMM dd";
              formatVertical   = "HH mm - dd MM";
              customFont       = "JetBrainsMono NF";
            }
            {
              id = "SystemMonitor";
              compactMode       = true;
              showCpuUsage      = true;
              showCpuTemp       = true;
              showMemoryUsage   = true;
              showSwapUsage     = true;
              useMonospaceFont  = true;
            }
            {
              id = "MediaMini";
              compactMode     = true;
              hideMode        = "hidden";
              maxWidth        = 200;
              scrollingMode   = "hover";
              showAlbumArt    = true;
              showProgressRing = true;
            }
            {
              id = "ActiveWindow";
              hideMode      = "hidden";
              maxWidth      = 160;
              scrollingMode = "hover";
              showIcon      = true;
            }
          ];
          center = [
            {
              id = "Workspace";
              enableScrollWheel = true;
              focusedColor      = "primary";
              fontWeight        = "bold";
              hideUnoccupied    = true;
              labelMode         = "index";
              pillSize          = 0.7;
              showApplications  = true;
              showBadge         = true;
              showLabelsOnlyWhenOccupied = true;
            }
          ];
          right = [
            { id = "Tray"; }
            { id = "NotificationHistory"; }
            { id = "plugin:tailscale"; }
            { id = "Network";    displayMode = "onhover"; }
            { id = "Bluetooth";  displayMode = "onhover"; }
            {
              id = "Battery";
              displayMode       = "graphic-clean";
              hideIfNotDetected = true;
            }
            { id = "Volume";     displayMode = "onhover"; }
            { id = "Brightness"; displayMode = "onhover"; }
            { id = "plugin:privacy-indicator"; }
            { id = "plugin:screen-recorder"; }
          ];
        };
      };

      general = {
        avatarImage            = "/home/${username}/.face";
        clockFormat            = "hh\\nmm";
        clockStyle             = "custom";
        compactLockScreen      = true;
        enableBlurBehind       = true;
        enableLockScreenCountdown = true;
        enableShadows          = false;
        lockOnSuspend          = true;
        lockScreenAnimations   = true;
        lockScreenBlur         = 0.4;
        lockScreenTint         = 0.4;
        passwordChars          = true;
        shadowDirection        = "center";
        shadowOffsetX          = 0;
        shadowOffsetY          = 0;
        showChangelogOnStartup = true;
        telemetryEnabled       = false;
        keybinds = {
          keyUp    = [ "Up"    "Alt+K" ];
          keyDown  = [ "Down"  "Alt+J" ];
          keyLeft  = [ "Left"  "Alt+H" ];
          keyRight = [ "Right" "Alt+L" ];
          keyEnter = [ "Return" "Enter" ];
          keyEscape = [ "Esc" ];
          keyRemove = [ "Del" ];
        };
      };

      ui = {
        fontDefault            = "JetBrainsMono NF";
        fontFixed              = "JetBrainsMono NF";
        panelBackgroundOpacity = 0.93;
        panelsAttachedToBar    = true;
        scrollbarAlwaysVisible = true;
        settingsPanelMode      = "window";
      };

      location = {
        name                    = "Stuttgart";
        useFahrenheit           = false;
        use12hourFormat         = false;
        firstDayOfWeek          = -1;
        analogClockInCalendar   = true;
        hideWeatherCityName     = true;
        showWeekNumberInCalendar = true;
        weatherShowEffects      = false;
      };

      appLauncher = {
        terminalCommand        = "alacritty -e";
        position               = "center";
        sortByMostUsed         = true;
        viewMode               = "list";
        enableClipboardHistory = true;
      };

      colorSchemes = {
        darkMode           = true;
        useWallpaperColors = true;
        predefinedScheme   = "Ayu";
        generationMethod   = "vibrant";
      };

      controlCenter = {
        position = "close_to_bar_button";
        cards = [
          { enabled = true; id = "profile-card"; }
          { enabled = true; id = "shortcuts-card"; }
          { enabled = true; id = "audio-card"; }
          { enabled = true; id = "brightness-card"; }
          { enabled = true; id = "weather-card"; }
          { enabled = true; id = "media-sysmon-card"; }
        ];
        shortcuts = {
          left = [
            { id = "Network"; }
            { id = "Bluetooth"; }
            { id = "WallpaperSelector"; }
            { id = "NoctaliaPerformance"; }
          ];
          right = [
            { id = "Notifications"; }
            { id = "PowerProfile"; }
            { id = "KeepAwake"; }
            { id = "NightLight"; }
          ];
        };
      };

      dock = {
        enabled        = true;
        dockType       = "static";
        displayMode    = "always_visible";
        position       = "bottom";
        size           = 1.2;
        floatingRatio  = 0.5;
        groupApps      = true;
        inactiveIndicators = true;
        pinnedApps     = [ "google-chrome" ];
        pinnedStatic   = true;
      };

      wallpaper = {
        enabled                  = true;
        directory                = "/home/${username}/Pictures/Wallpapers";
        fillMode                 = "center";
        setWallpaperOnAllMonitors = true;
        sortOrder                = "date_desc";
        transitionType           = "wipe";
        skipStartupTransition    = true;
        overviewBlur             = 0.8;
      };

      notifications = {
        enabled  = true;
        location = "top";
      };

      osd = {
        location   = "bottom";
        autoHideMs = 1500;
      };

      idle = {
        enabled          = true;
        screenOffTimeout = 600;
        lockTimeout      = 660;
        suspendTimeout   = 1800;
      };

      templates = {
        enableUserTheming = true;
        activeTemplates = [
          { enabled = true; id = "gtk"; }
          { enabled = true; id = "code"; }
          { enabled = true; id = "niri"; }
          { enabled = true; id = "ghostty"; }
          { enabled = true; id = "discord"; }
          { enabled = true; id = "spicetify"; }
          { enabled = true; id = "btop"; }
          { enabled = true; id = "kitty"; }
          { enabled = true; id = "alacritty"; }
          { enabled = true; id = "cava"; }
        ];
      };
    };
  };

  # ── GTK ──────────────────────────────────────────────────────────────────
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

  # ── Neovim (LazyVim — managed outside of Nix, config deployed as files) ─
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    viAlias       = true;
    vimAlias      = true;
  };

  # ── Shell ────────────────────────────────────────────────────────────────
  programs.fish = {
    enable = true;
    shellAbbrs = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#(hostname)";
      ff      = "fastfetch";
    };
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
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

  # ── Config file deployment ───────────────────────────────────────────────
  xdg.configFile = {
    "gtk-3.0/settings.ini".force = true;
    "gtk-4.0/settings.ini".force = true;
    "gtk-4.0/gtk.css".force      = true;

    # Niri
    "niri/config.kdl".source        = ../../config/niri/config.kdl;
    "niri/noctalia.kdl".source      = ../../config/niri/noctalia.kdl;
    "niri/cfg/keybinds.kdl".source  = ../../config/niri/cfg/keybinds.kdl;
    "niri/cfg/events.kdl".source    = ../../config/niri/cfg/events.kdl;
    "niri/cfg/gestures.kdl".source  = ../../config/niri/cfg/gestures.kdl;
    "niri/cfg/input.kdl".source     = ../../config/niri/cfg/input.kdl;
    "niri/cfg/display.kdl".source   = ../../config/niri/cfg/display.kdl;
    "niri/cfg/layout.kdl".source    = ../../config/niri/cfg/layout.kdl;
    "niri/cfg/rules.kdl".source     = ../../config/niri/cfg/rules.kdl;
    "niri/cfg/misc.kdl".source      = ../../config/niri/cfg/misc.kdl;
    "niri/cfg/animation.kdl".source = ../../config/niri/cfg/animation.kdl;

    # Neovim (LazyVim — plugins managed by lazy.nvim at runtime)
    "nvim/init.lua".source                  = ../../config/nvim/init.lua;
    "nvim/stylua.toml".source               = ../../config/nvim/stylua.toml;
    "nvim/.neoconf.json".source             = ../../config/nvim/.neoconf.json;
    "nvim/lua/config/lazy.lua".source       = ../../config/nvim/lua/config/lazy.lua;
    "nvim/lua/config/options.lua".source    = ../../config/nvim/lua/config/options.lua;
    "nvim/lua/config/keymaps.lua".source    = ../../config/nvim/lua/config/keymaps.lua;
    "nvim/lua/config/autocmds.lua".source   = ../../config/nvim/lua/config/autocmds.lua;
    "nvim/lua/plugins/base16.lua".source    = ../../config/nvim/lua/plugins/base16.lua;
    "nvim/lua/matugen-template.lua".source  = ../../config/nvim/lua/matugen-template.lua;

    # Noctalia user templates (nvim base16 theming via matugen)
    "noctalia/user-templates.toml".source = ../../config/noctalia/user-templates.toml;

    # Fastfetch
    "fastfetch/config.jsonc".source = ../../config/fastfetch/config.jsonc;
  };

  # ── User packages ───────────────────────────────────────────────────────
  home.packages = with pkgs; [
    fastfetch
    libsForQt5.qt5ct
  ];
}
