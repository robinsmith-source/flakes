{ config, lib, pkgs, ... }:
let
  cfg = config.workstation.hardware-amd;
in
{
  options.workstation.hardware-amd.enable = lib.mkEnableOption "AMD GPU and CPU hardware support";

  config = lib.mkIf cfg.enable {
    hardware.cpu.amd.updateMicrocode = true;
    boot.kernelParams = [ "amd_pstate=active" ];
    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };

    environment.systemPackages = with pkgs; [
      radeontop
      lm_sensors
      nvtopPackages.amd
    ];
  };
}
