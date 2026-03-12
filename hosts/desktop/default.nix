{ pkgs, username, ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "desktop";

  # Ryzen 7 7800X3D + Radeon RX 7800XT (RDNA 3)
  boot.kernelParams = [ "amdgpu.sg_display=0" ];

  workstation.niri.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    shell        = pkgs.zsh;
    extraGroups  = [ "wheel" "video" "audio" "networkmanager" "input" ];
  };

  system.stateVersion = "24.11";
}
