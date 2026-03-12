{ pkgs, username, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
  ];

  networking.hostName = "laptop";

  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  workstation = {
    baseline.enable = true;
    niri.enable = true;
    virtualization.enable = true;
  };

  services.power-profiles-daemon.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "lock";
  };

  hardware.acpilight.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "input" "libvirtd" ];
  };

  system.stateVersion = "25.11";
}
