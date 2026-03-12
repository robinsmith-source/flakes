{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.workstation;
in
{
  options.workstation = {
    niri.enable = lib.mkEnableOption "Niri scrollable-tiling Wayland compositor with Noctalia shell";
  };

  config = lib.mkIf cfg.niri.enable {
    # niri-flake NixOS module handles: polkit (KDE agent), xdg portals,
    # GNOME keyring, dconf, opengl, default fonts, binary cache.
    programs.niri.enable = true;

    # Noctalia prerequisites (per https://docs.noctalia.dev/getting-started/nixos/)
    # networkmanager, bluetooth — already in common.nix
    services.upower.enable = true;

    # Display manager
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --greeting 'Welcome' --cmd niri-session";
        user = "greeter";
      };
    };
    security.pam.services.greetd.enableGnomeKeyring = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL                = "1";
      ELECTRON_OZONE_PLATFORM_HINT  = "auto";
      MOZ_ENABLE_WAYLAND            = "1";
      QT_QPA_PLATFORM               = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_QPA_PLATFORMTHEME          = "gtk3";
      SDL_VIDEODRIVER               = "wayland";
      CLUTTER_BACKEND               = "wayland";
      XDG_SESSION_TYPE              = "wayland";
      XDG_CURRENT_DESKTOP           = "niri";
    };

    # xdg-desktop-portal-gtk needed alongside the -gnome one from niri-flake
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    environment.systemPackages = with pkgs; [
      xwayland-satellite
      wl-clipboard
      cliphist
      grim
      slurp
      playerctl
      brightnessctl
    ];
  };
}
