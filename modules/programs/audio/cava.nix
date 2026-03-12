{ ... }: {
  programs.cava = {
    enable = true;
    settings = {
      general = {
        framerate = 60;
        bars = 0;
        bar_width = 2;
        bar_spacing = 1;
      };
      smoothing.noise_reduction = 77;
    };
  };
}
