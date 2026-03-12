{ ... }: {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#(hostname)";
      ff = "fastfetch";
    };
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
}
