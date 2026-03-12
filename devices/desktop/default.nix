{ pkgs, username, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/baseline.nix
    ../../modules/niri.nix
    ../../modules/hardware-amd.nix
  ];

  networking.hostName = "desktop";

  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "amdgpu.sg_display=0" ];

  workstation = {
    baseline.enable     = true;
    niri.enable         = true;
    hardware-amd.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    shell        = pkgs.fish;
    extraGroups  = [ "wheel" "video" "audio" "networkmanager" "input" ];
  };

  system.stateVersion = "24.11";
}
