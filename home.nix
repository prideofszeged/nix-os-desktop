{ config, pkgs, lib, claude-code, ... }:

{
  # Home Manager basic info
  home.username = "dev";
  home.homeDirectory = "/home/dev";
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # User packages - Claude Code via nix flake
  home.packages = [
    claude-code.packages.${pkgs.system}.default
  ];

  # ========================================
  # SNAZZY RICE CONFIG - Catppuccin + Cyber
  # ========================================

  # i3 Window Manager Configuration
  home.file.".config/i3/config".source = ./dotfiles/i3/config-cyberpunk;

  # Polybar Status Bar
  home.file.".config/polybar/config.ini".source = ./dotfiles/polybar/config-cyberpunk.ini;
  home.file.".config/polybar/launch.sh" = {
    source = ./dotfiles/polybar/launch.sh;
    executable = true;
  };

  # Rofi Application Launcher
  home.file.".config/rofi/cyberpunk.rasi".source = ./dotfiles/rofi/cyberpunk.rasi;

  # Picom Compositor - ANIMATED VERSION!
  home.file.".config/picom/picom.conf".source = ./dotfiles/picom/picom-animated.conf;

  # Alacritty Terminal
  home.file.".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty/alacritty-cyberpunk.toml;

  # Starship Prompt Config
  home.file.".config/starship.toml".source = ./dotfiles/starship/starship.toml;

  # Dunst Notifications
  home.file.".config/dunst/dunstrc".source = ./dotfiles/dunst/dunstrc;

  # GTK Theme Configuration - Catppuccin Mocha!
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "standard";
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  };

  # Zsh with oh-my-zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "gitignore"
        "docker"
        "docker-compose"
        "kubectl"
        "python"
        "rust"
        "golang"
        "npm"
        "node"
        "sudo"
        "history"
        "colored-man-pages"
        "command-not-found"
        "extract"
      ];
    };

    initExtra = ''
      # Cyberpunk welcome banner
      if [ -f ~/.config/welcome.sh ]; then
        ~/.config/welcome.sh
      fi

      # Show Claude Code status on first terminal
      if [ ! -f /tmp/.claude-version-shown ]; then
        echo ""
        if command -v claude &> /dev/null; then
          CLAUDE_VER=$(claude --version 2>&1 || echo "unknown")
          echo "✅ Claude Code $CLAUDE_VER ready!"
        else
          echo "⚠️  Claude Code not found in PATH"
        fi
        touch /tmp/.claude-version-shown
        echo ""
      fi
    '';
  };

  # Git Configuration
  programs.git = {
    enable = true;
    userName = "Developer";
    userEmail = "dev@cyberpunk.local";
  };

  # Neovim
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  # Starship Prompt - enabled with custom config
  programs.starship = {
    enable = true;
  };

  # Basic shell aliases
  home.shellAliases = {
    ll = "ls -lah";
    cat = "bat";
    ls = "eza --icons";
  };

  # ========================================
  # WALLPAPER GENERATION - VERY BRIGHT!
  # ========================================
  home.activation.generateWallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/.config/wallpapers

    # "Very Bright" Cyberpunk Wallpaper - Catppuccin tones
    ${pkgs.imagemagick}/bin/convert -size 1920x1080 \
      -define gradient:angle=135 \
      gradient:'#2a1a4e-#1f5490' \
      \( -size 1920x1080 plasma:fractal -colorspace RGB -auto-level \
         -channel R -evaluate multiply 1.5 \
         -channel G -evaluate multiply 0.5 \
         -channel B -evaluate multiply 1.2 \
         +channel -modulate 150,200 \) \
      -compose screen -composite \
      \( -size 1920x1080 xc:none \
         -fill '#f5c2e744' -draw 'circle 960,540 960,250' \
         -fill '#cba6f744' -draw 'circle 400,300 400,150' \
         -fill '#94e2d544' -draw 'circle 1500,700 1500,200' \
         -fill '#89b4fa33' -draw 'circle 200,800 200,180' \
         -blur 0x100 \) \
      -compose screen -composite \
      ~/.config/wallpapers/cyberpunk.png

    # Symlink for i3 to find it
    ln -sf ~/.config/wallpapers/cyberpunk.png ~/.config/wallpaper.png
  '';
}
