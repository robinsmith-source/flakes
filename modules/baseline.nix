{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.workstation.baseline;
in
{
  options.workstation.baseline.enable = lib.mkEnableOption "Baseline workstation configuration";

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    nix = {
      registry.nixpkgs.flake = inputs.nixpkgs;
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store   = true;
        trusted-users         = [ "root" "@wheel" ];
      };
      gc = {
        automatic = true;
        dates     = "weekly";
        options   = "--delete-older-than 7d";
      };
    };

    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams   = [ "quiet" "splash" "loglevel=3" ];
      plymouth.enable = true;
      tmp.useTmpfs    = true;
    };

    hardware.enableAllFirmware = true;

    time.timeZone      = "Europe/Berlin";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8" ];
    console = {
      font   = "Lat2-Terminus16";
      keyMap = "us";
    };

    networking = {
      networkmanager.enable = true;
      firewall.enable       = true;
    };

    hardware.bluetooth = {
      enable      = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
      settings.Policy.AutoEnable    = true;
    };
    services.blueman.enable = true;

    services.pulseaudio.enable = false;
    security.rtkit.enable      = true;
    services.pipewire = {
      enable             = true;
      alsa.enable        = true;
      alsa.support32Bit  = true;
      pulse.enable       = true;
      wireplumber.enable = true;
    };

    services.tailscale.enable         = true;
    services.libinput.enable          = true;
    services.upower.enable            = true;
    services.gnome.gnome-keyring.enable = true;

    programs.fish.enable  = true;
    programs.dconf.enable = true;

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        inter
        noto-fonts
        noto-fonts-color-emoji
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = [ "Inter" "Noto Sans" ];
          serif     = [ "Noto Serif" ];
          monospace = [ "JetBrainsMono Nerd Font" ];
        };
      };
      fontDir.enable = true;
    };

    xdg.portal.enable = true;

    environment.systemPackages = with pkgs; [
      git
      curl
      google-chrome
      nautilus
      rose-pine-cursor
      papirus-icon-theme
      adw-gtk3
      adwaita-icon-theme
      libsForQt5.qt5ct
    ];

    zramSwap = { enable = true; algorithm = "zstd"; };
  };
}
