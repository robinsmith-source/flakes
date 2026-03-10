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
      options   = "--delete-older-than 14d";
    };
  };

  # !! Set your timezone !!
  time.timeZone      = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    networkmanager.enable = true;
    firewall.enable       = true;
  };

  hardware.bluetooth = { enable = true; powerOnBoot = true; };
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

  services.tailscale.enable = true;

  programs.zsh.enable    = true;
  programs.dconf.enable  = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [ git curl ];

  services.gnome.gnome-keyring.enable = true;

  boot = {
    kernelParams  = [ "quiet" "splash" "loglevel=3" ];
    plymouth.enable = true;
    tmp.useTmpfs  = true;
  };

  zramSwap = { enable = true; algorithm = "zstd"; };
}
