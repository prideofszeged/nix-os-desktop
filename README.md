# NixOS Developer Desktop VM - CYBERPUNK EDITION 🌃

A **fully automatic, 100% reproducible** NixOS virtual machine with cyberpunk-themed i3 window manager and development tools.

**🌟 See [README-CYBERPUNK.md](README-CYBERPUNK.md) for the full cyberpunk rice documentation!**

## ✨ Fully Automatic & Reproducible

- **NO manual setup** - Everything configured declaratively with Home Manager
- **NO internet required** - Wallpaper generated deterministically
- **Identical every boot** - Pure NixOS reproducibility
- **Just build and run** - Rice applies automatically
- **Rollback support** - Home Manager generations for easy rollback

**📖 See [HOME-MANAGER.md](HOME-MANAGER.md) for details on the Home Manager setup!**

## Features

### Window Manager & Desktop
- **i3wm** - Tiling window manager with vim-like keybindings
- **Polybar** - Beautiful status bar with system information
- **Rofi** - Modern application launcher
- **Picom** - Compositor for transparency and effects
- **Nord color scheme** - Consistent theming across all applications

### Development Tools
- **Node.js 20** - JavaScript runtime
- **Python 3.12** - With pip and virtualenv
- **Go** - Latest stable version
- **Rust** - With cargo, rustfmt, and rust-analyzer
- **Claude Code 2.0.64** - Anthropic's AI coding assistant (via npm)
- **Git & GitHub CLI** - Version control tools
- **VS Code** - Code editor
- **Neovim** - Terminal editor

### Terminals
- **Alacritty** - GPU-accelerated terminal (default)
- **Ghostty** - Modern, fast GPU terminal
- **Kitty** - Feature-rich GPU terminal
- All configured with cyberpunk themes!

### Shell & Prompt
- **ZSH** with oh-my-zsh (15+ plugins)
- **Starship** prompt (cyberpunk theme)
- Tab completion and smart features

### System Utilities
- **Firefox & Chromium** - Web browsers
- **htop & btop** - System monitors
- **ripgrep, fd, fzf** - Modern CLI tools

## Quick Start

### 1. Build the VM (first time only)

```bash
chmod +x build-vm.sh run-vm.sh
./build-vm.sh
```

This will take 10-15 minutes on first build as it downloads and builds all packages.

### 2. Run the VM

```bash
./run-vm.sh
```

### 3. Enjoy!

- **Auto-login** enabled (user: dev)
- **Cyberpunk rice** loads automatically
- **All tools ready** - No setup needed!

i3 starts automatically with full cyberpunk theme, blur, transparency, and neon colors.

## i3 Keybindings

**Note:** `Super` = Windows key (⊞) on most keyboards

### Essential Keys
- `Super + Enter` - Open terminal (Alacritty)
- `Super + Shift + Enter` - Open Ghostty terminal
- `Super + Ctrl + Enter` - Open Kitty terminal
- `Super + D` - Launch application (Rofi)
- `Super + Shift + Q` - Close window
- `Super + Shift + E` - Exit i3
- `Super + Shift + R` - Restart i3

### Window Management
- `Super + H/J/K/L` - Focus window (left/down/up/right)
- `Super + Shift + H/J/K/L` - Move window
- `Super + 1-9` - Switch to workspace 1-9
- `Super + Shift + 1-9` - Move window to workspace
- `Super + F` - Toggle fullscreen
- `Super + Shift + Space` - Toggle floating

### Layout
- `Super + V` - Split vertical
- `Super + B` - Split horizontal
- `Super + S` - Stacking layout
- `Super + W` - Tabbed layout
- `Super + E` - Toggle split layout
- `Super + R` - Resize mode (then H/J/K/L to resize)

### Other
- `Print` - Screenshot (Flameshot)
- `Super + Shift + X` - Lock screen

## Development Workflow

### Using Claude Code

Claude Code 2.0.64 is automatically installed and available:

```bash
# Verify installation
claude --version
# Output: 2.0.64

# Get help
claude --help

# Run Claude Code
claude
```

**📖 See [CLAUDE-CODE.md](CLAUDE-CODE.md) for complete Claude Code setup documentation!**

#### Troubleshooting Claude Code

If `claude` command is not found, use the diagnostic tools in `~/.local/bin/`:

```bash
# Diagnose the issue (shows Node, npm, Claude, PATH status)
check-claude

# Install manually
install-claude

# Then open a new terminal and try again
claude --version
```

These scripts are copied to `~/.local/bin/` by Home Manager and should be in your PATH automatically.

### Language Setup

**Node.js:**
```bash
node --version
npm --version
```

**Python:**
```bash
python --version
pip --version
# Create virtual environment
python -m venv venv
source venv/bin/activate
```

**Go:**
```bash
go version
```

**Rust:**
```bash
rustc --version
cargo --version
```

## Customization

### Configuration Structure

- **configuration.nix** - System-level config (packages, services, X11)
- **home.nix** - User-level config (dotfiles, programs, themes) via Home Manager
- **dotfiles/** - Source files for all rice configs

### Add System Packages

Edit `configuration.nix` and add packages to `environment.systemPackages`:

```nix
environment.systemPackages = with pkgs; [
  # Add your packages here
  docker
  kubernetes
  # etc.
];
```

### Customize User Config

Edit `home.nix` to change user-level settings:

```nix
programs.git = {
  enable = true;
  userName = "Your Name";
  userEmail = "your@email.com";
};
```

### Modify Dotfiles

Edit files in `dotfiles/`:
- `i3/config-cyberpunk` - Window manager keybindings and colors
- `polybar/config-cyberpunk.ini` - Status bar modules and appearance
- `alacritty/alacritty-cyberpunk.toml` - Terminal colors and opacity
- `rofi/cyberpunk.rasi` - App launcher theme
- `picom/picom-cyberpunk.conf` - Compositor blur and transparency

### Customize Wallpaper

The wallpaper brightness and colors can be adjusted in `home.nix`:

**📖 See [WALLPAPER-CUSTOMIZATION.md](WALLPAPER-CUSTOMIZATION.md) for complete wallpaper customization guide!**

Quick brightness adjustment:
```nix
# In home.nix, find home.activation.generateWallpaper
-modulate 150,200  # Brighter (was 120,180)
-modulate 100,150  # Darker
```

### Apply Changes

After any edit:
```bash
./build-vm.sh
./run-vm.sh
```

Changes are applied automatically! Home Manager handles all dotfile deployment.

## VM Specs

- **RAM:** 8GB (adjustable in configuration.nix)
- **CPU Cores:** 4 (adjustable)
- **Disk:** 40GB (adjustable)
- **Display:** Virtio GPU with OpenGL

## File Structure

```
.
├── flake.nix                  # Nix flake with Home Manager
├── configuration.nix          # System-level NixOS config
├── home.nix                   # User-level Home Manager config
├── dotfiles/                  # Source dotfiles
│   ├── i3/                   # i3 window manager config
│   ├── polybar/              # Polybar status bar config
│   ├── rofi/                 # Rofi launcher theme
│   ├── picom/                # Compositor config
│   ├── alacritty/            # Terminal config
│   └── welcome.sh            # Cyberpunk welcome banner
├── build-vm.sh               # Build script
├── run-vm.sh                 # Run script
├── README.md                 # This file
├── README-CYBERPUNK.md       # Cyberpunk rice guide
├── HOME-MANAGER.md           # Home Manager documentation
├── CLAUDE-CODE.md            # Claude Code setup guide
├── TERMINALS-AND-SHELL.md    # Terminals, ZSH, oh-my-zsh, Starship guide
├── PATH-SETUP.md             # PATH configuration explained
├── WALLPAPER-CUSTOMIZATION.md # Wallpaper brightness/color guide
├── DECLARATIVE-RICE.md       # Technical rice details
└── TODO.md                   # Planned/completed work
```

## Tips

1. **Mouse Release:** Press `Ctrl+Super+G` to release mouse from VM
2. **Full Screen:** Use VM window's fullscreen option for better experience
3. **Shared Clipboard:** May work depending on QEMU guest additions
4. **Network:** VM has network access via NAT

## Next Steps: Replacing Your Desktop

Once you're happy with this VM configuration, you can:

1. **Install NixOS on bare metal** using the same configuration files
2. **Modify** `configuration.nix` to remove VM-specific settings:
   - Remove `virtualisation.vmVariant` section
   - Add hardware-specific config
   - Configure bootloader
3. **Keep configs in Git** for easy deployment and rollback

## Troubleshooting

### VM won't start
- Ensure you ran `./build-vm.sh` first
- Check you have enough free RAM (8GB required)

### Display issues
- Try different QEMU display backends in `run-vm.sh`
- Adjust resolution in i3 config

### Claude Code not found
- The activation script installs it on first boot
- Reboot the VM if needed: `sudo reboot`

## Resources

- [i3 User Guide](https://i3wm.org/docs/userguide.html)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Claude Code Docs](https://docs.anthropic.com/claude-code)

Enjoy your developer-focused NixOS desktop! 🚀
