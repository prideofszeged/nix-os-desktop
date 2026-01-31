{ config, pkgs, ... }:

{
  # VM-specific settings with virtio-gpu (no GL - NVIDIA host incompatible with virgl)
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 12288;  # 12GB RAM
      cores = 6;
      diskSize = 60000;   # 60GB disk
      qemu.options = [
        "-vga qxl"
        "-spice port=5930,disable-ticketing=on"
        "-device virtio-serial-pci"
        "-chardev spicevmc,id=vdagent,name=vdagent"
        "-device virtserialport,chardev=vdagent,name=com.redhat.spice.0"
      ];
      # Persistent storage shared from host via 9p
      sharedDirectories.persist = {
        source = "/mnt/nvme/nix-vm-persist";
        target = "/persist";
      };
    };
  };

  # SPICE/QEMU guest services for clipboard, resolution, etc.
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

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
    lazygit
    delta
    neovim
    vim
    vscode
    tmux
    ripgrep
    fd
    fzf
    jq
    yq
    htop
    btop
    tree
    wget
    curl
    httpie
    direnv

    # Docker & Containers
    docker
    docker-compose

    # Database Clients
    postgresql
    redis
    sqlite

    # i3 Window Manager & Rice
    i3
    i3status
    i3lock
    polybar
    rofi
    picom-pijulius  # Animated picom fork!
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
    bat     # Better cat
    eza     # Better ls with icons

    # Fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
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

    # Theming - Catppuccin!
    lxappearance
    catppuccin-gtk
    papirus-icon-theme

    # Screen & Display
    arandr
    autorandr

    # SPICE clipboard support
    spice-vdagent
    xclip         # X11 clipboard utilities
    xsel          # Alternative X11 clipboard

    # CYBERPUNK AESTHETIC TOOLS
    neofetch
    cava
    lolcat
    figlet
    imagemagick
    cmatrix
    pipes
    cbonsai

    # Required for GTK theme settings via home-manager
    dconf
  ];

  # Enable dconf - required for GTK settings in home-manager
  programs.dconf.enable = true;

  # X11 and i3 configuration
  services.xserver = {
    enable = true;
    dpi = 96;

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

  # GPU acceleration for virtio-gpu (virgl)
  hardware.graphics.enable = true;

  # Audio - PipeWire (default in unstable)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;  # PulseAudio compatibility
  };
  # Explicitly disable PulseAudio to avoid conflict
  services.pulseaudio.enable = false;

  # Compositing - DISABLED, using picom-pijulius from i3 startup
  # services.picom = {
  #   enable = true;
  #   fade = true;
  #   shadow = true;
  #   fadeDelta = 4;
  # };

  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    font-awesome
  ];

  # User configuration
  users.users.dev = {
    isNormalUser = true;
    description = "Developer";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" ];
    password = "dev";
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;  # ZSH configured via Home Manager
  };

  # NOTE: All dotfile management moved to Home Manager (home.nix)
  # NOTE: Claude Code installation also moved to Home Manager

  # Enable sudo without password for convenience (VM only!)
  security.sudo.wheelNeedsPassword = false;

  # ZSH and Git are configured per-user via Home Manager
  # Don't enable them here to avoid file conflicts

  # Network configuration
  networking.hostName = "nixos-dev";
  networking.networkmanager.enable = true;

  # Timezone
  time.timeZone = "America/New_York";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Serial console for headless mode
  boot.kernelParams = [ "console=tty1" "console=ttyS0,115200" ];

  # Enable SSH for remote access
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = true;
  };

  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # Direnv integration
  programs.direnv.enable = true;

  # System state version
  system.stateVersion = "24.05";
}
