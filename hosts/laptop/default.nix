{ pkgs, username, ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "laptop";

  # Lenovo Ideapad 5 Pro 14ARH7 — AMD Ryzen 6000 (Rembrandt), Radeon 680M iGPU
  services.power-profiles-daemon.enable = true;

  services.logind = {
    lidSwitch              = "suspend";
    lidSwitchExternalPower = "lock";
  };

  hardware.acpilight.enable = true;   # backlight control (user in `video` group)

  users.users.${username} = {
    isNormalUser = true;
    shell        = pkgs.zsh;
    extraGroups  = [ "wheel" "video" "audio" "networkmanager" "input" ];
    # Set your password after first boot: passwd <username>
  };

  # Set to the NixOS version that was current when this machine was first installed.
  # Do NOT change this after the initial install.
  system.stateVersion = "24.11";
}
