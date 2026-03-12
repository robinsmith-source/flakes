{ pkgs, ... }: {
  # AMD CPU microcode updates
  hardware.cpu.amd.updateMicrocode = true;

  # amd_pstate active mode — better power/perf scaling on Zen 3+
  boot.kernelParams = [ "amd_pstate=active" ];

  # Load amdgpu early so the display is available from the first initrd screen.
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Mesa (RADV) is the default Vulkan driver — no extra Vulkan packages needed.
  hardware.graphics = {
    enable      = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd            # OpenCL via ROCm (needed for GPU compute)
    ];
  };

  # GPU monitoring tools
  environment.systemPackages = with pkgs; [
    radeontop          # GPU utilisation
    lm_sensors         # Temperature / fan sensors
    nvtopPackages.amd  # GPU process monitor (htop for GPUs)
  ];
}
