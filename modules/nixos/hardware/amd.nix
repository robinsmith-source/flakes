{ pkgs, ... }: {
  # AMD CPU microcode updates
  hardware.cpu.amd.updateMicrocode = true;

  # Load amdgpu early so the display is available from the first initrd screen.
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Mesa (RADV) is always included by default; only add supplementary drivers.
  hardware.graphics = {
    enable      = true;
    enable32Bit = true;               # needed for Steam / 32-bit games
    extraPackages = with pkgs; [
      amdvlk                          # AMD's official Vulkan driver (opt-in fallback)
      rocmPackages.clr.icd            # OpenCL via ROCm (needed for GPU compute)
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  # GPU monitoring tools
  environment.systemPackages = with pkgs; [
    radeontop          # GPU utilisation
    lm_sensors         # Temperature / fan sensors
    nvtopPackages.amd  # GPU process monitor (htop for GPUs)
  ];
}
