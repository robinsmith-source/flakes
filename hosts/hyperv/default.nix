{ pkgs, lib, username, ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "hyperv";

  # ── Override AMD hardware (not present in the VM) ──────────────────────────
  hardware.cpu.amd.updateMicrocode  = lib.mkForce false;
  # hyperv_drm is a KMS/DRM driver for the Hyper-V synthetic GPU.
  # It lets niri (smithay) open a DRM device just like on real hardware.
  boot.initrd.kernelModules         = lib.mkForce [ "hyperv_drm" ];
  services.xserver.videoDrivers     = lib.mkForce [ "modesetting" ];
  hardware.graphics.extraPackages   = lib.mkForce [];
  hardware.graphics.extraPackages32 = lib.mkForce [];

  # ── Hyper-V guest integration ──────────────────────────────────────────────
  virtualisation.hypervGuest.enable = true;
  # hv_sock is required for Enhanced Session (RDP tunnelled over VMBus).
  boot.kernelModules = [ "hv_sock" ];

  # ── Enhanced Session via xrdp ──────────────────────────────────────────────
  # In Hyper-V Manager click "Connect" then switch to Enhanced Session to get
  # a proper resizable display, clipboard, and audio redirection.
  services.xrdp = {
    enable               = true;
    defaultWindowManager = "niri-session";
    openFirewall         = true;
  };
  security.pam.services.xrdp-sesman.enableGnomeKeyring = true;

  # ── Autologin (convenient for testing — not for production) ───────────────
  services.greetd.settings.default_session.command = lib.mkForce
    "${pkgs.tuigreet}/bin/tuigreet --time --autologin ${username} --cmd niri-session";

  users.users.${username} = {
    isNormalUser    = true;
    shell           = pkgs.zsh;
    extraGroups     = [ "wheel" "video" "audio" "networkmanager" "input" ];
    initialPassword = "test";   # change immediately: passwd <username>
  };

  system.stateVersion = "24.11";
}
