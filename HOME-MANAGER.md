# Home Manager Configuration Guide

## What is Home Manager?

Home Manager is the **idiomatic NixOS way** to manage user-level configurations and dotfiles declaratively. Instead of using system activation scripts or manual file copying, Home Manager provides:

- ✅ **Declarative dotfile management** - Define all your configs in Nix
- ✅ **Per-user configurations** - Different users can have different setups
- ✅ **Rollback capability** - Undo configuration changes easily
- ✅ **Generations** - Track history of your dotfile changes
- ✅ **Integration with system config** - Works seamlessly with NixOS

## How We Use It

### File Structure

```
.
├── flake.nix              # Imports home-manager and home.nix
├── configuration.nix      # System-level config (packages, services)
├── home.nix              # User-level config (dotfiles, programs)
└── dotfiles/             # Source files for configs
    ├── i3/
    ├── polybar/
    ├── rofi/
    ├── picom/
    └── alacritty/
```

### flake.nix

Imports Home Manager and connects it to the user:

```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  home-manager = {
    url = "github:nix-community/home-manager/release-24.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};

outputs = { self, nixpkgs, home-manager }: {
  nixosConfigurations.dev-vm = nixpkgs.lib.nixosSystem {
    modules = [
      ./configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.dev = import ./home.nix;
      }
    ];
  };
};
```

### home.nix

Manages all user dotfiles and programs:

```nix
{
  # Basic info
  home.username = "dev";
  home.homeDirectory = "/home/dev";
  home.stateVersion = "24.05";

  # Copy dotfiles
  home.file.".config/i3/config".source = ./dotfiles/i3/config-cyberpunk;
  home.file.".config/polybar/config.ini".source = ./dotfiles/polybar/config-cyberpunk.ini;

  # Executable files
  home.file.".config/polybar/launch.sh" = {
    source = ./dotfiles/polybar/launch.sh;
    executable = true;
  };

  # Generate wallpaper deterministically
  home.activation.generateWallpaper = ''
    # ImageMagick commands to create wallpaper
  '';

  # Configure programs declaratively
  programs.zsh = {
    enable = true;
    oh-my-zsh.enable = true;
    # ... config
  };

  programs.git = {
    enable = true;
    userName = "Developer";
    # ... config
  };

  # GTK theme
  gtk = {
    enable = true;
    theme.name = "Arc-Dark";
    # ... config
  };
}
```

## Advantages Over Activation Scripts

### Before (System Activation Scripts)

```nix
# configuration.nix
system.activationScripts.dotfiles = ''
  cp -f /etc/nixos/dotfiles/i3/config /home/dev/.config/i3/config
  cp -f /etc/nixos/dotfiles/polybar/config.ini /home/dev/.config/polybar/config.ini
  # Manual copying, no rollback, no generations
'';
```

**Problems:**
- ❌ Runs as root (ownership issues)
- ❌ No rollback capability
- ❌ Can't have per-user configs easily
- ❌ Manual permission management
- ❌ Not the idiomatic NixOS way

### After (Home Manager)

```nix
# home.nix
home.file.".config/i3/config".source = ./dotfiles/i3/config-cyberpunk;
home.file.".config/polybar/config.ini".source = ./dotfiles/polybar/config-cyberpunk.ini;
```

**Benefits:**
- ✅ Runs as user (correct ownership)
- ✅ Rollback with `home-manager generations`
- ✅ Multiple users, each with own home.nix
- ✅ Automatic permission handling
- ✅ The NixOS way!

## Making Changes

### Edit Dotfiles

1. **Edit the source file**:
   ```bash
   vim dotfiles/i3/config-cyberpunk
   ```

2. **Rebuild**:
   ```bash
   ./build-vm.sh
   ```

3. **Changes apply automatically** on next boot!

### Edit Home Manager Config

1. **Edit home.nix**:
   ```bash
   vim home.nix
   ```

2. **Add new dotfile**:
   ```nix
   home.file.".config/myapp/config".source = ./dotfiles/myapp/config;
   ```

3. **Rebuild and run**:
   ```bash
   ./build-vm.sh
   ./run-vm.sh
   ```

## Home Manager Commands

Inside the VM, you can use Home Manager directly:

```bash
# Check current generation
home-manager generations

# Rollback to previous generation
home-manager rollback

# List all generations
ls -la ~/.local/state/home-manager/profiles/

# Switch to specific generation
/nix/store/<hash>-home-manager-generation/activate
```

## What Home Manager Manages

In our cyberpunk setup:

### Dotfiles
- i3 window manager config
- Polybar status bar config
- Rofi launcher theme
- Picom compositor config
- Alacritty terminal config
- Welcome script

### Programs
- ZSH with oh-my-zsh
- Git with user info
- Neovim
- Starship prompt

### Themes
- GTK theme (Arc-Dark)
- Icon theme (Papirus-Dark)
- Cursor theme (Adwaita)

### Custom Scripts
- Wallpaper generation (via home.activation)
- Welcome banner

## Separation of Concerns

### configuration.nix (System Level)
- System packages (Node, Python, Go, Rust, etc.)
- System services (X11, NetworkManager, etc.)
- Users and groups
- Boot configuration
- Security settings

### home.nix (User Level)
- User dotfiles (~/.config/*)
- User programs (zsh, git, neovim)
- User themes (GTK, icons)
- User-specific scripts
- Shell aliases

## Advanced: Per-User Configs

You can have different configs for different users:

```nix
# flake.nix
home-manager.users.dev = import ./home.nix;
home-manager.users.admin = import ./home-admin.nix;
```

Each user gets their own dotfiles and configurations!

## Why This Matters

**Traditional approach:**
```bash
# Install dotfiles manually
git clone https://github.com/user/dotfiles ~/.dotfiles
./install.sh  # Hope it works!
```

**NixOS + Home Manager:**
```nix
# Define once in home.nix
home.file.".config/i3/config".source = ./dotfiles/i3/config;

# Apply everywhere
nix build && ./run-vm.sh
# Identical result every time!
```

## Learning More

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
- [NixOS Wiki](https://nixos.wiki/wiki/Home_Manager)

This is the declarative, reproducible way to manage your dotfiles! 🏠
