{ pkgs, ... }: {
  # Enable CachyOS binary cache via chaotic-nyx
  # This significantly speeds up builds by pulling CachyOS-built binaries
  chaotic.nyx.cache.enable = true;

  # CachyOS LTS kernel with BORE scheduler and optimisations
  # Available after chaotic.nixosModules.default applies the overlay
  boot.kernelPackages = pkgs.linuxPackages_cachyos-lts;

  # Clean boot parameters
  boot.kernelParams = [
    "quiet"
    "splash"
    "loglevel=3"
    "systemd.show_status=auto"
    # amd_pstate active mode — better power/perf scaling on Zen 3+
    "amd_pstate=active"
  ];

  # Plymouth boot splash
  boot.plymouth.enable = true;

  # Use tmpfs for /tmp (CachyOS default — improves performance)
  boot.tmp.useTmpfs = true;

  # Zram swap — compresses RAM, CachyOS enables this by default
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
