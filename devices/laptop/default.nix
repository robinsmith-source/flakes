{ pkgs, username, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/baseline.nix
    ../../modules/niri.nix
    ../../modules/hardware-amd.nix
  ];

  networking.hostName = "laptop";

  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  workstation = {
    baseline.enable     = true;
    niri.enable         = true;
    hardware-amd.enable = true;
  };

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

  virtualisation.vmVariant.virtualisation = {
    memorySize = 4096;
    cores      = 4;
    diskSize   = 20480;
  };

  virtualisation.virtualbox.guest.enable = false;

  system.stateVersion = "24.11";
}
