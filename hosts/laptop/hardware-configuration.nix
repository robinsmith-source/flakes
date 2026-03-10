# !! Replace this file with the output of: nixos-generate-config --show-hardware-config !!
# Run on the target machine and paste the result here, then remove this comment.
{ modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Placeholder — replace with nixos-generate-config output
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  swapDevices = [];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set correct platform
  nixpkgs.hostPlatform = "x86_64-linux";
}
