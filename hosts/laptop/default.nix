{ pkgs, username, ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "laptop";

  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Lenovo Ideapad 5 Pro 14ARH7 — AMD Ryzen 6000 (Rembrandt), Radeon 680M iGPU
  hardware.cpu.amd.updateMicrocode = true;

  workstation.niri.enable = true;

  services.power-profiles-daemon.enable = true;

  services.logind = {
    lidSwitch              = "suspend";
    lidSwitchExternalPower = "lock";
  };

  hardware.acpilight.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    shell        = pkgs.zsh;
    extraGroups  = [ "wheel" "video" "audio" "networkmanager" "input" ];
  };

  system.stateVersion = "24.11";
}
