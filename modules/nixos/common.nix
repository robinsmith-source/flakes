{ pkgs, lib, inputs, ... }: {
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

  time.timeZone      = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font   = "Lat2-Terminus16";
    keyMap = "us";
  };

  networking = {
    networkmanager.enable = true;
    firewall.enable       = true;
  };

  hardware = {
    enableAllFirmware = true;
    bluetooth = {
      enable      = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
      settings.Policy.AutoEnable    = true;
    };
  };
  services.blueman.enable = true;

  # ── Audio (PipeWire) ─────────────────────────────────────────────────────
  services.pulseaudio.enable = false;
  security.rtkit.enable      = true;
  services.pipewire = {
    enable             = true;
    alsa.enable        = true;
    alsa.support32Bit  = true;
    pulse.enable       = true;
    wireplumber.enable = true;
  };

  # ── Services ─────────────────────────────────────────────────────────────
  services.tailscale.enable = true;
  services.libinput.enable  = true;
  services.upower.enable    = true;
  services.gnome.gnome-keyring.enable = true;

  # ── Programs ─────────────────────────────────────────────────────────────
  programs.fish.enable  = true;
  programs.dconf.enable = true;

  # ── Fonts ────────────────────────────────────────────────────────────────
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
        sansSerif  = [ "Inter" "Noto Sans" ];
        serif      = [ "Noto Serif" ];
        monospace  = [ "JetBrainsMono Nerd Font" ];
      };
    };
    fontDir.enable = true;
  };

  # ── System packages ──────────────────────────────────────────────────────
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

  # ── Boot (CachyOS LTS kernel — BORE scheduler + performance patches) ────
  boot = {
    kernelPackages = inputs.nix-cachyos-kernel.legacyPackages.${pkgs.stdenv.hostPlatform.system}.linuxPackages-cachyos-lts;
    kernelParams   = [ "quiet" "splash" "loglevel=3" ];
    plymouth.enable = true;
    tmp.useTmpfs    = true;
  };

  zramSwap = { enable = true; algorithm = "zstd"; };
}
