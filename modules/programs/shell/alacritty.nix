{ ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window = {
        dynamic_padding = true;
        decorations = "full";
        opacity = 0.9;
        padding = { x = 6; y = 6; };
        decorations_theme_variant = "Dark";
        dimensions = { columns = 100; lines = 30; };
      };
      scrolling = { history = 10000; multiplier = 3; };
      font = {
        size = 12.0;
        normal = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
        bold = { family = "JetBrainsMono Nerd Font"; style = "Bold"; };
        italic = { family = "JetBrainsMono Nerd Font"; style = "Italic"; };
        bold_italic = { family = "JetBrainsMono Nerd Font"; style = "Bold Italic"; };
      };
      colors.draw_bold_text_with_bright_colors = true;
      selection = {
        semantic_escape_chars = '',│`|:"' ()[]{}<>\t'';
        save_to_clipboard = true;
      };
      cursor = {
        style = "Underline";
        unfocused_hollow = true;
        thickness = 0.15;
      };
      mouse.hide_when_typing = true;
    };
  };
}
