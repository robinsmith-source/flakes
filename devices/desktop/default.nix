{ pkgs, username, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ./amd.nix
    ../../modules/programs/gaming
  ];

  networking.hostName = "desktop";

  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "amdgpu.sg_display=0" ];

  workstation = {
    baseline.enable = true;
    niri.enable = true;
    hardware-amd.enable = true;
    gaming.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "input" "libvirtd" ];
  };

  system.stateVersion = "25.11";
}
