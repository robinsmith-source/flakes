{ pkgs, ... }: {
  # Niri — scrollable-tiling Wayland compositor
  programs.niri.enable = true;

  # Noctalia shell systemd service (started after graphical-session.target)
  services.noctalia-shell.enable = true;

  # Required by Noctalia for power profile switching
  services.upower.enable = true;

  # Display manager: greetd + tuigreet (lightweight, Wayland-native)
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --greeting 'Welcome' --cmd niri-session";
      user = "greeter";
    };
  };

  # Wayland environment variables (picked up by all sessions)
  environment.sessionVariables = {
    NIXOS_OZONE_WL     = "1";   # Electron apps run native Wayland
    MOZ_ENABLE_WAYLAND = "1";   # Firefox Wayland
    QT_QPA_PLATFORM    = "wayland;xcb";
    SDL_VIDEODRIVER    = "wayland";
    CLUTTER_BACKEND    = "wayland";
    XDG_SESSION_TYPE   = "wayland";
  };

  # XDG portals — required for screen sharing, file pickers, etc.
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  # PAM keyring unlock on login
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Polkit for privilege escalation prompts
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy    = [ "graphical-session.target" ];
    wants       = [ "graphical-session.target" ];
    after       = [ "graphical-session.target" ];
    serviceConfig = {
      Type           = "simple";
      ExecStart      = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart        = "on-failure";
      RestartSec     = 1;
      TimeoutStopSec = 10;
    };
  };

  environment.systemPackages = with pkgs; [
    # Core Wayland utilities
    wofi              # App launcher
    mako              # Notification daemon
    swaylock          # Screen locker
    swayidle          # Idle → lock → suspend
    grim              # Screenshot (whole screen)
    slurp             # Screenshot (region selection)
    wl-clipboard      # wl-copy / wl-paste
    cliphist          # Clipboard history manager
    playerctl         # Media key control
    brightnessctl     # Backlight control

    # Polkit agent
    polkit_gnome

    # GTK / icon themes
    adw-gtk3
    papirus-icon-theme
    adwaita-icon-theme
  ];
}
