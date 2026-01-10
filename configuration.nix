{ config, pkgs, ... }:

{
  # VM-specific settings
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;  # 8GB RAM
      cores = 4;
      diskSize = 40960;   # 40GB disk
      qemu.options = [
        "-vga virtio"
        # Display set via QEMU_OPTS in run script for flexibility
      ];
    };
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages (needed for VS Code, etc.)
  nixpkgs.config.allowUnfree = true;

  # Enable nix-ld to run dynamic binaries (needed for Claude Code)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add common libraries that dynamic binaries expect
    stdenv.cc.cc.lib
    zlib
    openssl
    curl
  ];

  # System packages - Development tools + Desktop environment
  environment.systemPackages = with pkgs; [
    # Development Languages & Tools
    nodejs_20
    python312
    python312Packages.pip
    python312Packages.virtualenv
    go
    rustc
    cargo
    rustfmt
    rust-analyzer

    # Development Utilities
    git
    gh
    neovim
    vim
    vscode
    tmux
    ripgrep
    fd
    fzf
    jq
    htop
    btop
    tree
    wget
    curl

    # i3 Window Manager & Rice
    i3
    i3status
    i3lock
    polybar
    rofi
    picom
    dunst
    feh
    nitrogen
    flameshot

    # Terminal & Shell
    alacritty
    kitty
    # ghostty - Not yet in nixpkgs 24.05 (too new!)
    # Can be added later when available
    zsh
    oh-my-zsh
    starship

    # Fonts
    jetbrains-mono
    nerdfonts
    font-awesome

    # GUI Applications
    firefox
    chromium

    # File Management
    ranger
    pcmanfm

    # System Tools
    xorg.xbacklight
    acpi
    pavucontrol
    playerctl

    # Theming
    lxappearance
    arc-theme
    papirus-icon-theme

    # Screen & Display
    arandr
    autorandr

    # CYBERPUNK AESTHETIC TOOLS
    neofetch
    cava
    lolcat
    figlet
    imagemagick
    cmatrix
    pipes
    cbonsai
  ];

  # X11 and i3 configuration
  services.xserver = {
    enable = true;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
      ];
    };

    # Keyboard layout
    xkb.layout = "us";
  };

  # Display Manager (moved from services.xserver.displayManager)
  services.displayManager = {
    defaultSession = "none+i3";
    autoLogin = {
      enable = true;
      user = "dev";
    };
  };

  # LightDM
  services.xserver.displayManager.lightdm.enable = true;

  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Compositing for transparency and effects
  services.picom = {
    enable = true;
    fade = true;
    shadow = true;
    fadeDelta = 4;
  };

  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "DroidSansMono" ]; })
    font-awesome
  ];

  # User configuration
  users.users.dev = {
    isNormalUser = true;
    description = "Developer";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    password = "dev";
    shell = pkgs.zsh;
  };

  # NOTE: All dotfile management moved to Home Manager (home.nix)
  # NOTE: Claude Code installation also moved to Home Manager

  # Enable sudo without password for convenience (VM only!)
  security.sudo.wheelNeedsPassword = false;

  # Enable ZSH system-wide (configured per-user in Home Manager)
  programs.zsh.enable = true;

  # Enable Git system-wide (configured per-user in Home Manager)
  programs.git.enable = true;

  # Network configuration
  networking.hostName = "nixos-dev";
  networking.networkmanager.enable = true;

  # Timezone
  time.timeZone = "America/New_York";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable SSH for remote access
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = true;
  };

  # System state version
  system.stateVersion = "24.05";
}
