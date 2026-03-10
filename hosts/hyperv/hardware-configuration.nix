# Generated inside the VM with: nixos-generate-config --show-hardware-config
# Replace this file with that output, then run: nixos-rebuild switch --flake .#hyperv
{ modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  swapDevices = [];

  boot.loader.systemd-boot.enable        = true;
  boot.loader.efi.canTouchEfiVariables   = true;

  nixpkgs.hostPlatform = "x86_64-linux";
}
