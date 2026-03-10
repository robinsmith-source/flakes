{ pkgs, lib, inputs, username, ... }: {
  # Only allow the specific unfree packages we actually use
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "google-chrome"
      "spotify"
      "discord"
    ];

  # ── Nix daemon settings ────────────────────────────────────────────────────
  nix = {
    # Pin the system flake registry + legacy NIX_PATH to the locked nixpkgs.
    # This makes `nix run nixpkgs#foo` and `nix-shell -p foo` use the same
    # nixpkgs revision that the system was built with.
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    settings = {
      experimental-features  = [ "nix-command" "flakes" ];
      auto-optimise-store    = true;
      trusted-users          = [ "root" "@wheel" ];
      # Keep build inputs & derivations so direnv / nix develop shells
      # survive garbage collection.
      keep-outputs           = true;
      keep-derivations       = true;
    };

    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 14d";
    };
  };

  # !! Set your timezone !!
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_TIME = "de_DE.UTF-8";

  # ── Networking ─────────────────────────────────────────────────────────────
  networking = {
    networkmanager.enable = true;
    firewall.enable       = true;
  };

  # ── Bluetooth ──────────────────────────────────────────────────────────────
  hardware.bluetooth = {
    enable       = true;
    powerOnBoot  = true;
  };
  services.blueman.enable = true;

  # ── Audio (PipeWire) ───────────────────────────────────────────────────────
  hardware.pulseaudio.enable = false;
  security.rtkit.enable      = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    jack.enable       = true;
    wireplumber.enable = true;
  };

  # ── VPN ────────────────────────────────────────────────────────────────────
  services.tailscale.enable = true;

  # ── Shell ──────────────────────────────────────────────────────────────────
  # Must be enabled at system level for zsh to be a valid login shell.
  programs.zsh.enable = true;

  # Required for home-manager dconf / GTK settings to take effect.
  programs.dconf.enable = true;

  # ── Fonts ──────────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.noto
    inter
  ];

  # ── System packages ────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    htop
    btop
    unzip
    p7zip
    file
    pciutils
    usbutils
  ];

  # ── GNOME Keyring ──────────────────────────────────────────────────────────
  services.gnome.gnome-keyring.enable = true;
}
