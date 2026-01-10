{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "dev";
  home.homeDirectory = "/home/dev";

  # This value determines the Home Manager release that your
  # configuration is compatible with.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Add home-manager to user packages for CLI access
  home.packages = with pkgs; [
    # Empty for now, packages added below
  ];

  # ========================================
  # CYBERPUNK DOTFILES - Fully Declarative!
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

  # Picom Compositor
  home.file.".config/picom/picom.conf".source = ./dotfiles/picom/picom-cyberpunk.conf;

  # Alacritty Terminal
  home.file.".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty/alacritty-cyberpunk.toml;

  # Ghostty Terminal
  home.file.".config/ghostty/config".source = ./dotfiles/ghostty/config;

  # Welcome Script
  home.file.".config/welcome.sh" = {
    source = ./dotfiles/welcome.sh;
    executable = true;
  };

  # Claude Code scripts in ~/.local/bin
  home.file.".local/bin/install-claude" = {
    source = ./dotfiles/install-claude.sh;
    executable = true;
  };

  home.file.".local/bin/check-claude" = {
    source = ./dotfiles/check-claude.sh;
    executable = true;
  };

  home.file.".local/bin/debug-claude-install" = {
    source = ./dotfiles/debug-claude-install.sh;
    executable = true;
  };

  home.file.".local/bin/show-install-logs" = {
    source = ./dotfiles/show-install-logs.sh;
    executable = true;
  };

  # Generate Cyberpunk Wallpaper (deterministic, BRIGHT & VIBRANT!)
  home.activation.generateWallpaper = ''
    mkdir -p ~/.config/wallpapers

    # Always regenerate for brightness update
    ${pkgs.imagemagick}/bin/convert -size 1920x1080 \
      -define gradient:angle=135 \
      gradient:'#1a0a2e-#0f3460' \
      \( -size 1920x1080 plasma:fractal -colorspace RGB -auto-level \
         -channel R -evaluate multiply 1.2 \
         -channel G -evaluate multiply 0.3 \
         -channel B -evaluate multiply 1.0 \
         +channel -modulate 120,180 \) \
      -compose screen -composite \
      \( -size 1920x1080 xc:none \
         -fill '#ff0a7822' -draw 'circle 960,540 960,200' \
         -fill '#bf00ff22' -draw 'circle 400,300 400,100' \
         -fill '#00f5ff22' -draw 'circle 1500,700 1500,500' \
         -blur 0x80 \) \
      -compose screen -composite \
      -blur 0x1 \
      ~/.config/wallpapers/cyberpunk.png

    ln -sf ~/.config/wallpapers/cyberpunk.png ~/.config/wallpaper.png
  '';

  # GTK Theme Configuration
  gtk = {
    enable = true;
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
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

  # Zsh Configuration with oh-my-zsh and Cyberpunk Welcome
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # Oh-My-Zsh configuration
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";  # Theme doesn't matter - Starship overrides the prompt
      plugins = [
        # Version control
        "git"
        "gitignore"

        # Languages & tools
        "docker"
        "docker-compose"
        "kubectl"
        "python"
        "rust"
        "golang"
        "npm"
        "node"

        # Utilities
        "sudo"          # Press ESC twice to add sudo
        "history"       # History search
        "colored-man-pages"
        "command-not-found"
        "extract"       # Smart archive extraction
      ];
    };
    initExtra = ''
      # Ensure PATH includes our custom directories
      # (Home Manager should set this via sessionPath, but be explicit)
      export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
      export NPM_CONFIG_PREFIX="$HOME/.npm-global"

      # Cyberpunk welcome banner
      ~/.config/welcome.sh

      # Show Claude Code status on first terminal
      if [ ! -f /tmp/.claude-version-shown ]; then
        echo ""
        if command -v claude &> /dev/null; then
          CLAUDE_VER=$(claude --version 2>&1 || echo "unknown")
          echo "✅ Claude Code $CLAUDE_VER ready!"
        else
          echo "⚠️  Claude Code not found in PATH"
          echo ""
          echo "   Diagnostic commands:"
          echo "   • debug-claude-install  - Full diagnostic report"
          echo "   • check-claude          - Quick status check"
          echo "   • install-claude        - Manual installation"
          echo ""
          echo "   Check activation logs:"
          echo "   • journalctl --user -u home-manager-dev.service"
          echo "   • systemctl --user status claude-code-installer"
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

  # Starship Prompt - CYBERPUNK THEME
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      # Cyberpunk prompt character
      character = {
        success_symbol = "[](bold #00f5ff)";  # Neon cyan
        error_symbol = "[](bold #ff0a78)";    # Neon pink
        vimcmd_symbol = "[](bold #bf00ff)";   # Neon purple
      };

      # Directory
      directory = {
        style = "bold #bf00ff";  # Neon purple
        truncation_length = 3;
        truncate_to_repo = true;
      };

      # Git
      git_branch = {
        symbol = " ";
        style = "bold #00f5ff";  # Neon cyan
      };

      git_status = {
        style = "bold #ff0a78";  # Neon pink
        ahead = " ⇡\${count}";
        behind = " ⇣\${count}";
        diverged = " ⇕⇡\${ahead_count}⇣\${behind_count}";
        staged = " +\${count}";
        modified = " ~\${count}";
        untracked = " ?\${count}";
      };

      # Languages
      nodejs = {
        symbol = " ";
        style = "bold #00ff9f";  # Green
      };

      python = {
        symbol = " ";
        style = "bold #ffbd00";  # Yellow
      };

      rust = {
        symbol = " ";
        style = "bold #ff6600";  # Orange
      };

      golang = {
        symbol = " ";
        style = "bold #00f5ff";  # Cyan
      };

      # Time
      time = {
        disabled = false;
        format = "[$time]($style) ";
        style = "bold #888888";  # Gray
        time_format = "%H:%M";
      };

      # Command duration
      cmd_duration = {
        min_time = 500;
        format = "took [$duration]($style) ";
        style = "bold #ffbd00";  # Yellow
      };
    };
  };

  # Additional shell aliases
  home.shellAliases = {
    ll = "ls -lah";
    ".." = "cd ..";
    "..." = "cd ../..";
    nf = "neofetch";
    matrix = "cmatrix -b";
  };

  # Node.js and npm configuration
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  # Add directories to PATH
  home.sessionPath = [
    "$HOME/.local/bin"        # Our scripts (check-claude, install-claude)
    "$HOME/.npm-global/bin"   # npm global packages (Claude Code)
  ];

  # Install Claude Code 2.0.64 using official installer
  home.activation.installClaudeCode = config.lib.dag.entryAfter ["writeBoundary"] ''
    set -x  # Enable verbose logging
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Installing Claude Code 2.0.64..."
    echo "Running as: $(whoami)"
    echo "HOME: $HOME"
    echo "PWD: $(pwd)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Set up npm global directory
    mkdir -p $HOME/.npm-global
    export NPM_CONFIG_PREFIX="$HOME/.npm-global"
    export PATH="$HOME/.npm-global/bin:$PATH"

    echo "NPM_CONFIG_PREFIX: $NPM_CONFIG_PREFIX"
    echo "PATH: $PATH"

    # Configure npm prefix
    echo "Configuring npm prefix..."
    ${pkgs.nodejs_20}/bin/npm config set prefix "$HOME/.npm-global"
    echo "npm prefix is now: $(${pkgs.nodejs_20}/bin/npm config get prefix)"

    # Use official Claude Code installation script
    if [ ! -f $HOME/.npm-global/bin/claude ]; then
      echo "Claude binary not found, installing..."
      echo "Trying official installer..."

      if ${pkgs.curl}/bin/curl -fsSL https://claude.ai/install.sh | ${pkgs.bash}/bin/bash -s -- 2.0.64; then
        echo "✅ Official installer completed"
      else
        echo "⚠️  Official installer failed (exit code: $?), trying npm fallback..."
        ${pkgs.nodejs_20}/bin/npm install -g @anthropic-ai/claude-code@2.0.64
      fi
    else
      echo "Claude Code already installed at $HOME/.npm-global/bin/claude"
    fi

    # Verify installation
    echo "Verifying installation..."
    if [ -f $HOME/.npm-global/bin/claude ]; then
      echo "✅ Claude Code installed successfully!"
      echo "Location: $HOME/.npm-global/bin/claude"
      ls -lh $HOME/.npm-global/bin/claude

      export PATH="$HOME/.npm-global/bin:$PATH"
      if $HOME/.npm-global/bin/claude --version 2>&1; then
        echo "✅ Version check passed"
      else
        echo "⚠️  Version check failed (exit code: $?)"
      fi
    else
      echo "❌ Claude Code binary not found at $HOME/.npm-global/bin/claude"
      echo "Contents of ~/.npm-global/bin/:"
      ls -la $HOME/.npm-global/bin/ 2>&1 || echo "Directory does not exist or is empty"
      echo ""
      echo "Global npm packages:"
      ${pkgs.nodejs_20}/bin/npm list -g --depth=0 2>&1 || echo "No global packages"
      echo ""
      echo "Run 'debug-claude-install' for detailed diagnostics"
      echo "Run 'install-claude' to manually install"
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    set +x  # Disable verbose logging
  '';

  # Systemd user service to ensure Claude Code is installed on first boot
  systemd.user.services.claude-code-installer = {
    Unit = {
      Description = "Install Claude Code on first boot";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c 'export PATH=$HOME/.npm-global/bin:$PATH; if [ ! -f $HOME/.npm-global/bin/claude ]; then ${pkgs.curl}/bin/curl -fsSL https://claude.ai/install.sh | ${pkgs.bash}/bin/bash -s -- 2.0.64; fi'";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
