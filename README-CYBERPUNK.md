# 🌃 NixOS CYBERPUNK Desktop - Fully Automatic Edition

A **100% reproducible** cyberpunk-themed developer desktop that looks identical every single boot.

## ✨ Key Feature: FULLY AUTOMATIC

Unlike typical rices that require manual setup:
- ❌ NO downloading wallpapers from the internet
- ❌ NO running setup scripts
- ❌ NO manual configuration
- ✅ **Everything is declarative and reproducible**
- ✅ **Identical on every boot**
- ✅ **Works offline**

## 🎨 What You Get

### Automatic Cyberpunk Rice
- **Neon colors**: Pink (#ff0a78), Purple (#bf00ff), Cyan (#00f5ff)
- **Heavy transparency**: 85% opacity on all windows
- **Dual Kawase blur**: Strength 8 for that glass effect
- **3px neon borders**: Pink on active windows
- **Rounded corners**: 12px radius
- **Wide gaps**: 15px inner, 10px outer

### Automatic Startup
On every boot, automatically:
1. Generates deterministic cyberpunk wallpaper
2. Applies GTK theme (Arc-Dark + Papirus icons)
3. Starts Polybar status bar
4. Starts Picom compositor with blur
5. Sets wallpaper via feh
6. Shows cyberpunk welcome banner in terminal

### Development Tools (Pre-installed)
- Node.js 20, Python 3.12, Go, Rust
- Claude Code (npm global install)
- Git, GitHub CLI, VS Code, Neovim
- Modern CLI: ripgrep, fd, fzf, btop

### Aesthetic Tools
- neofetch, cava, lolcat, figlet
- cmatrix, pipes, cbonsai
- All pre-configured and ready to use

## 🚀 Quick Start

```bash
# Build (first time, 10-15 min)
./build-vm.sh

# Run - cyberpunk rice loads automatically!
./run-vm.sh
```

That's it! No setup scripts, no configuration needed.

## 🎯 Using the Desktop

**Note:** `Super` = Windows key (⊞) on your keyboard

### Essential Shortcuts
- `Super + Enter` - Terminal
- `Super + D` - App launcher (Rofi)
- `Super + Shift + Q` - Close window
- `Super + 1-9` - Workspaces
- `Super + H/J/K/L` - Navigate windows

### Try These
```bash
neofetch                        # System info
cava                            # Audio visualizer (play music first)
figlet CYBERPUNK | lolcat      # Rainbow ASCII art
cmatrix                         # Matrix effect
pipes                           # Animated pipes
```

## 📁 How It Works

### Declarative Configuration
Everything is defined in `configuration.nix`:
- System packages (dev tools + aesthetic tools)
- X11 + i3 window manager
- Display manager with auto-login
- GTK theme configuration

### Activation Scripts
On every boot, NixOS runs activation scripts that:
1. Copy cyberpunk dotfiles to `~/.config/`
2. Generate deterministic wallpaper using ImageMagick
3. Apply GTK theme settings
4. Set up terminal welcome banner

### i3 Autostart
The i3 config automatically starts:
- Polybar (status bar)
- Picom (compositor with blur)
- Feh (wallpaper setter)
- Dunst (notifications)

### Deterministic Wallpaper
Generated using ImageMagick with:
- Gradient from #0a0e14 to #1a1a2e
- Plasma fractal overlay (purple/pink tones)
- Blur effect
- **Same output every time** (no randomness, no downloads)

## 🔧 Customization

All configs are in `dotfiles/`:
- `i3/config-cyberpunk` - Window manager
- `polybar/config-cyberpunk.ini` - Status bar
- `rofi/cyberpunk.rasi` - App launcher
- `picom/picom-cyberpunk.conf` - Compositor
- `alacritty/alacritty-cyberpunk.toml` - Terminal

Edit these, rebuild, and your changes apply everywhere.

## 🌈 Why This Is Better

### Traditional Rice Problems:
```bash
# User installs Arch + i3
sudo pacman -S i3 polybar picom
curl https://some-wallpaper.jpg > ~/.wallpaper  # Breaks if site is down
vim ~/.config/i3/config                         # Manual editing
picom &                                         # Manual startup
feh --bg-scale ~/.wallpaper                     # Manual command
# Different on every install, breaks without internet
```

### NixOS Declarative Rice:
```nix
# Define EVERYTHING in configuration.nix
environment.systemPackages = [ i3 polybar picom ... ];
system.activationScripts.wallpaper = ''
  ${pkgs.imagemagick}/bin/convert ...  # Deterministic!
'';
# Rebuild: nix build .#vm
# Result: IDENTICAL every time, works offline
```

## 🎨 Color Palette

```
Neon Pink:   #ff0a78  ████
Neon Purple: #bf00ff  ████
Neon Cyan:   #00f5ff  ████
Neon Blue:   #0066ff  ████
Background:  #0a0e14  ████
Super BG:      #1a1a2e  ████
Foreground:  #e0e0e0  ████
```

## 📊 VM Specs

- RAM: 8GB (configurable in configuration.nix)
- CPU: 4 cores (configurable)
- Disk: 40GB (configurable)
- Display: Virtio GPU
- Auto-login: Enabled (user: dev, password: dev)

## 🔄 Making Changes

1. Edit `configuration.nix` or files in `dotfiles/`
2. Run `./build-vm.sh`
3. Run `./run-vm.sh`
4. Changes apply automatically!

Example - change border color:
```nix
# In dotfiles/i3/config-cyberpunk
set $neon-pink           #00ff00  # Change to green
```

Rebuild and it's applied everywhere consistently.

## 📖 See Also

- `CYBERPUNK.md` - Detailed guide to all features
- `TODO.md` - Planned enhancements
- `configuration.nix` - Main system config

## 🎯 Next Steps

Once you're happy with the VM:
1. Use the same configs for bare-metal NixOS install
2. All your rice configs are already in version control
3. Deploy to any machine with `nixos-rebuild`

Enjoy your fully automatic, reproducible cyberpunk desktop! 🚀
