# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **fully declarative, reproducible NixOS VM** with a cyberpunk-themed i3 window manager and complete development tooling. Everything is configured through Nix flakes and Home Manager - no manual setup required.

## Build and Run Commands

### Building the VM
```bash
./build-vm.sh
```
First build takes 10-15 minutes. Uses Nix flakes to build the entire system.

### Running the VM
```bash
./run-vm.sh
```
Starts QEMU with 8GB RAM, 4 cores. Auto-login as user `dev` (password: `dev`).

### Testing Changes
After any config change:
```bash
./build-vm.sh && ./run-vm.sh
```

## Architecture

### Three-Layer Configuration System

1. **flake.nix** - Entry point that imports Home Manager and connects components
2. **configuration.nix** - System-level NixOS config (packages, X11, services, VM specs)
3. **home.nix** - User-level config via Home Manager (dotfiles, programs, themes)

**Key principle:** System packages go in `configuration.nix`, user dotfiles and program configs go in `home.nix`.

### Home Manager Integration

All dotfiles are managed declaratively through Home Manager in `home.nix`:

```nix
# Copy dotfiles from source
home.file.".config/i3/config".source = ./dotfiles/i3/config-cyberpunk;

# Make scripts executable
home.file.".local/bin/check-claude" = {
  source = ./dotfiles/check-claude.sh;
  executable = true;
};

# Generate files at activation time
home.activation.generateWallpaper = ''
  # Shell commands that run when Home Manager activates
'';
```

**Never manually copy files** - always use Home Manager's `home.file` attribute. Changes apply automatically on rebuild.

### Dotfiles Structure

All source dotfiles live in `dotfiles/`:
- `i3/config-cyberpunk` - Window manager config with vim-like keybindings
- `polybar/config-cyberpunk.ini` - Status bar with neon colors and system info
- `rofi/cyberpunk.rasi` - Application launcher theme
- `picom/picom-cyberpunk.conf` - Compositor with dual kawase blur
- `alacritty/alacritty-cyberpunk.toml` - Terminal with transparency
- `ghostty/config` - Modern GPU terminal theme

These are referenced in `home.nix` and deployed by Home Manager.

## Adding Packages

### System Packages
Edit `configuration.nix`, add to `environment.systemPackages`:
```nix
environment.systemPackages = with pkgs; [
  # Your package here
  docker
];
```

### User Programs
Edit `home.nix`, configure via `programs.<name>`:
```nix
programs.git = {
  enable = true;
  userName = "Your Name";
  aliases = { ... };
};
```

## Customizing the Rice

### Colors and Themes
All cyberpunk colors are defined in individual dotfiles:
- i3 borders: `dotfiles/i3/config-cyberpunk` (lines with `client.focused`)
- Polybar: `dotfiles/polybar/config-cyberpunk.ini` (under `[colors]`)
- Rofi: `dotfiles/rofi/cyberpunk.rasi`
- Alacritty: `dotfiles/alacritty/alacritty-cyberpunk.toml` (under `[colors]`)

### Wallpaper Generation
Wallpaper is generated deterministically in `home.nix` using ImageMagick (home.activation.generateWallpaper:80).

To adjust brightness:
```nix
-modulate 120,180  # Current: moderate brightness
-modulate 150,200  # Brighter
-modulate 100,150  # Darker
```

To change colors, modify gradient values and plasma channel multipliers.

### VM Specifications
Edit `configuration.nix` under `virtualisation.vmVariant`:
```nix
virtualisation = {
  memorySize = 8192;  # RAM in MB
  cores = 4;          # CPU cores
  diskSize = 40960;   # Disk in MB
};
```

## Claude Code Setup

Claude Code 2.0.64 is installed automatically using a **dual installation mechanism**:

1. **Home Manager Activation** (home.activation.installClaudeCode:269):
   - Uses official installer: `curl -fsSL https://claude.ai/install.sh | bash -s -- 2.0.64`
   - Falls back to npm if official installer fails
   - Runs during VM build

2. **Systemd User Service** (systemd.user.services.claude-code-installer:308):
   - Backup installation on first boot
   - Waits for network connectivity
   - Only runs if Claude Code is not already installed

Installation details:
- Installs to `~/.npm-global/bin/claude`
- PATH configured in ZSH via `home.sessionPath`
- Diagnostic scripts: `check-claude` and `install-claude` in `~/.local/bin/`

If installation fails, users can run `check-claude` for diagnostics or `install-claude` for manual installation.

## PATH Configuration

PATH is managed by Home Manager in `home.nix`:
```nix
home.sessionPath = [
  "$HOME/.local/bin"        # Custom scripts
  "$HOME/.npm-global/bin"   # npm global packages
];
```

Environment variables:
```nix
home.sessionVariables = {
  NPM_CONFIG_PREFIX = "$HOME/.npm-global";
};
```

See PATH-SETUP.md for detailed explanation.

## i3 Window Manager

Window manager uses **Super (Windows key)** as mod key. Critical keybindings:
- `Super+Enter` - Alacritty terminal
- `Super+Shift+Enter` - Ghostty terminal
- `Super+D` - Rofi app launcher
- `Super+H/J/K/L` - Focus windows (vim-style)
- `Super+1-9` - Switch workspaces
- `Super+Shift+Q` - Close window
- `Super+Shift+R` - Restart i3

See `dotfiles/i3/config-cyberpunk` for full keybindings.

## Development Tools Installed

- Node.js 20, Python 3.12, Go, Rust (with cargo, rustfmt, rust-analyzer)
- Git, GitHub CLI, Neovim, VS Code
- ripgrep, fd, fzf, jq, htop, btop
- ZSH with oh-my-zsh (15+ plugins) and Starship prompt

All available immediately in the VM.

## Common Mistakes to Avoid

1. **Don't use system activation scripts** - Use Home Manager's `home.file` and `home.activation` instead
2. **Don't download external resources** - Keep everything deterministic and offline-capable
3. **Don't mix system and user config** - System packages in `configuration.nix`, user dotfiles in `home.nix`
4. **Don't forget to rebuild** - Changes to Nix files require `./build-vm.sh` to take effect
5. **Don't edit deployed dotfiles** - Edit source files in `dotfiles/`, not `~/.config/` in the VM

## Key Documentation Files

- HOME-MANAGER.md - Detailed Home Manager usage and rationale
- DECLARATIVE-RICE.md - Technical details on deterministic rice configuration
- WALLPAPER-CUSTOMIZATION.md - How to adjust wallpaper colors and brightness
- CLAUDE-CODE.md - Claude Code installation and troubleshooting
- TERMINALS-AND-SHELL.md - Terminal emulators, ZSH, and Starship configuration
- PATH-SETUP.md - How PATH and npm are configured

## Reproducibility Philosophy

This project embodies the NixOS philosophy:
- **Deterministic**: Same inputs → same outputs, always
- **Offline-first**: No network dependencies (wallpaper generated, not downloaded)
- **Declarative**: Entire system defined in code
- **Reproducible**: Build on any machine, get identical result
- **Version-controlled**: All configs in Git, rollback anytime

When making changes, preserve these principles. Generate, don't download. Declare, don't script.
