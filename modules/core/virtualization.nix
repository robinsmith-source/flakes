{ config, lib, pkgs, ... }:
let
  cfg = config.workstation.virtualization;
in
{
  options.workstation.virtualization.enable = lib.mkEnableOption "VM testing overrides (QEMU resources, disable VirtualBox guest)";

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [
      qemu_kvm
      libvirt
      virt-manager
    ];

    virtualisation.vmVariant.virtualisation = {
      memorySize = 4096;
      cores = 4;
      diskSize = 20480;
    };

    virtualisation.virtualbox.guest.enable = false;
  };
}
