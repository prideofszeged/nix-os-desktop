{ config, pkgs, lib, ... }:

{
  # Home Manager basic info
  home.username = "dev";
  home.homeDirectory = "/home/dev";
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # ========================================
  # MINIMAL CONFIG - Testing home-manager
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

  # Minimal Zsh - no oh-my-zsh, no complex initExtra
  programs.zsh = {
    enable = true;
    enableCompletion = true;
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

  # Starship Prompt - minimal
  programs.starship = {
    enable = true;
  };

  # Basic shell aliases
  home.shellAliases = {
    ll = "ls -lah";
  };
}
