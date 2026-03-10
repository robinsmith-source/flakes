{ pkgs, username, ... }: {
  home = {
    username     = username;
    homeDirectory = "/home/${username}";
    stateVersion  = "24.11";
  };

  programs.home-manager.enable = true;
  xdg.enable = true;

  # ── GTK ────────────────────────────────────────────────────────────────────
  gtk = {
    enable    = true;
    theme      = { name = "adw-gtk3-dark";  package = pkgs.adw-gtk3; };
    iconTheme  = { name = "Papirus-Dark";   package = pkgs.papirus-icon-theme; };
    cursorTheme = { name = "Adwaita"; size = 24; package = pkgs.adwaita-icon-theme; };
  };
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # ── Terminal ───────────────────────────────────────────────────────────────
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "JetBrainsMono Nerd Font";
        size = 12.0;
      };
      window.opacity = 0.95;
    };
  };

  # ── Shell ──────────────────────────────────────────────────────────────────
  programs.zsh = {
    enable                    = true;
    enableCompletion          = true;
    autosuggestion.enable     = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos/config#$(hostname)";
    };
  };

  # ── Git ────────────────────────────────────────────────────────────────────
  programs.git = {
    enable    = true;
    userName  = "Your Name";   # !! change me !!
    userEmail = "your@email.com";
    settings.init.defaultBranch = "main";
  };

  # ── Noctalia ───────────────────────────────────────────────────────────────
  programs.noctalia-shell = {
    enable         = true;
    systemd.enable = true;
    settings = {
      bar.position      = "top";
      launcher.terminal = "alacritty";
    };
  };

  # ── Niri ───────────────────────────────────────────────────────────────────
  home.file.".config/niri/config.kdl".source = ../../config/niri/config.kdl;
}
