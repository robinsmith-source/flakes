{ pkgs, username, ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "laptop";

  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Lenovo Ideapad 5 Pro 14ARH7 — AMD Ryzen 6000 (Rembrandt), Radeon 680M iGPU
  hardware.cpu.amd.updateMicrocode = true;

  workstation.niri.enable = true;

  services.power-profiles-daemon.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch              = "suspend";
    HandleLidSwitchExternalPower = "lock";
  };

  hardware.acpilight.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    shell        = pkgs.fish;
    extraGroups  = [ "wheel" "video" "audio" "networkmanager" "input" ];
  };

  # VM testing overrides (only applies to nixos-rebuild build-vm)
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores      = 4;
      diskSize   = 20480;
    };
  };

  system.stateVersion = "24.11";
}
