{ username, hostName, ... }: {
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

      notifications = { enabled = true; location = "top"; };
      osd           = { location = "bottom"; autoHideMs = 1500; };

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

  xdg.configFile = let
    niriBase = ../config/niri;
    niriHost = ../config/niri/hosts + "/${hostName}";
  in {
    "niri/config.kdl".source        = niriBase + "/config.kdl";
    "niri/noctalia.kdl".source      = niriBase + "/noctalia.kdl";
    "niri/cfg/autostart.kdl".source = niriBase + "/cfg/autostart.kdl";
    "niri/cfg/keybinds.kdl".source  = niriBase + "/cfg/keybinds.kdl";
    "niri/cfg/events.kdl".source    = niriBase + "/cfg/events.kdl";
    "niri/cfg/gestures.kdl".source  = niriBase + "/cfg/gestures.kdl";
    "niri/cfg/layout.kdl".source    = niriBase + "/cfg/layout.kdl";
    "niri/cfg/rules.kdl".source     = niriBase + "/cfg/rules.kdl";
    "niri/cfg/misc.kdl".source      = niriBase + "/cfg/misc.kdl";
    "niri/cfg/animation.kdl".source = niriBase + "/cfg/animation.kdl";
    "niri/cfg/display.kdl".source   = niriHost + "/display.kdl";
    "niri/cfg/input.kdl".source     = niriHost + "/input.kdl";
  };
}
