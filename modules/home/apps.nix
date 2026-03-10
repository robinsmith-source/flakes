{ pkgs, ... }: {
  home.packages = with pkgs; [
    # ── Password manager ───────────────────────────────────────────────────
    bitwarden-desktop   # GUI vault
    bitwarden-cli       # CLI (bw) for scripting / browser extension companion

    # ── Browser ────────────────────────────────────────────────────────────
    google-chrome       # unfree — declared in allowUnfreePredicate

    # ── Music ──────────────────────────────────────────────────────────────
    spotify             # unfree

    # ── Communication ──────────────────────────────────────────────────────
    discord             # unfree

    # ── File management ────────────────────────────────────────────────────
    nautilus            # GTK file manager
    file-roller         # Archive manager (integrates with Nautilus)

    # ── Media ──────────────────────────────────────────────────────────────
    mpv                 # Video player
    imv                 # Image viewer (Wayland-native)
  ];
}
