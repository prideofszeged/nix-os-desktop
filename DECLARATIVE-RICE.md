# Declarative Cyberpunk Rice - Technical Details

## The Problem We Solved

### Before (Imperative Rice)
The original `rice.sh` script had issues:
```bash
#!/usr/bin/env bash
# Download wallpapers from internet
curl -L "https://images.unsplash.com/photo..." -o ~/wallpaper.jpg

# Apply GTK theme manually
gsettings set org.gnome.desktop.interface gtk-theme "Arc-Dark"
```

**Problems:**
- ❌ Requires internet connection
- ❌ Non-deterministic (URLs can break, images can change)
- ❌ Must be run manually after each rebuild
- ❌ Not reproducible across machines
- ❌ Violates NixOS philosophy

### After (Declarative Rice)
Everything in `configuration.nix`:
```nix
system.activationScripts.dotfiles = ''
  # Generate wallpaper deterministically using ImageMagick
  ${pkgs.imagemagick}/bin/convert -size 1920x1080 \
    -define gradient:angle=135 \
    gradient:'#0a0e14-#1a1a2e' \
    ... # Deterministic plasma fractal
    $USER_HOME/.config/wallpapers/cyberpunk.png

  # Apply GTK theme via config file
  cat > $USER_HOME/.config/gtk-3.0/settings.ini <<EOF
  [Settings]
  gtk-theme-name=Arc-Dark
  ...
  EOF
'';
```

**Benefits:**
- ✅ Works offline
- ✅ Deterministic (same output every time)
- ✅ Runs automatically on every rebuild
- ✅ Reproducible on any machine
- ✅ True NixOS declarative configuration

## How It Works

### 1. System Activation Scripts

NixOS runs these on every `nixos-rebuild` or VM boot:

```nix
system.activationScripts.dotfiles = ''
  # Runs during system activation
  # Has access to all Nix packages via ${pkgs.package}
  # Can create files, set permissions, etc.
'';
```

Our script:
1. Copies all dotfiles to `/home/dev/.config/`
2. Generates wallpaper using ImageMagick
3. Creates GTK theme config files
4. Sets proper ownership (dev:users)

### 2. Deterministic Wallpaper Generation

Uses ImageMagick to create the same wallpaper every time:

```nix
${pkgs.imagemagick}/bin/convert -size 1920x1080 \
  -define gradient:angle=135 \
  gradient:'#0a0e14-#1a1a2e' \          # Dark gradient base
  \( -size 1920x1080 plasma:fractal \    # Plasma fractal
     -colorspace RGB -auto-level \
     -channel R -evaluate multiply 0.8 \ # More purple/pink
     -channel G -evaluate multiply 0.1 \
     -channel B -evaluate multiply 0.6 \
     +channel -modulate 100,150 \) \
  -compose overlay -composite \          # Overlay fractal
  -blur 0x2 \                            # Slight blur
  $USER_HOME/.config/wallpapers/cyberpunk.png
```

**Why deterministic:**
- No random seeds
- Same parameters every time
- No network dependencies
- Pure function: same inputs → same output

### 3. Automatic Startup

i3 config contains:
```bash
exec_always --no-startup-id ~/.config/polybar/launch.sh
exec_always --no-startup-id picom -b
exec --no-startup-id feh --bg-scale ~/.config/wallpaper.png
exec --no-startup-id dunst
```

These run automatically when i3 starts (which happens on login).

### 4. Dotfiles Management

All configs in `dotfiles/` directory:
```
dotfiles/
├── i3/config-cyberpunk
├── polybar/config-cyberpunk.ini
├── rofi/cyberpunk.rasi
├── picom/picom-cyberpunk.conf
└── alacritty/alacritty-cyberpunk.toml
```

Copied via:
```nix
environment.etc."nixos/dotfiles".source = ./dotfiles;
```

Then activation script copies to user home:
```nix
cp -f $DOTFILES_SRC/i3/config-cyberpunk $USER_HOME/.config/i3/config
# etc.
```

## Reproducibility Guarantees

### Same Machine, Multiple Boots
✅ **Guaranteed identical** - All configs and wallpaper are deterministic

### Different Machines
✅ **Guaranteed identical** - As long as they use the same `configuration.nix`

### After nixos-rebuild
✅ **Automatically re-applied** - Activation scripts run on every rebuild

### Offline
✅ **Works completely offline** - No network dependencies

### Time-independent
✅ **Same in 1 year** - No external dependencies to break

## Comparison to Other Approaches

### Traditional Arch/Ubuntu Rice
```bash
# Install packages manually
sudo pacman -S i3 polybar picom

# Download dotfiles
git clone https://github.com/user/dotfiles ~/.dotfiles
ln -s ~/.dotfiles/i3 ~/.config/i3

# Download wallpaper
curl https://wallhaven.cc/api/... > ~/.wallpaper

# Apply manually
picom &
feh --bg-scale ~/.wallpaper
```

**Issues:**
- Manual steps on every install
- Git repo might disappear
- Wallpaper URL might break
- Different on every machine (timing, versions)

### Home Manager (NixOS)
```nix
home-manager.users.dev = {
  programs.i3 = {
    enable = true;
    config = ''
      # i3 config here
    '';
  };
};
```

**Better but:**
- More complex (separate tool)
- Overkill for single-user VM
- Extra learning curve

### Our Approach (System Activation Scripts)
```nix
system.activationScripts.rice = ''
  # Generate everything deterministically
  ${pkgs.imagemagick}/bin/convert ...
'';

environment.etc."nixos/dotfiles".source = ./dotfiles;
```

**Perfect for:**
- Single-user systems
- VMs
- Maximum simplicity
- Direct NixOS features (no extra tools)

## Future: Converting to NixOS Skill

To make this reusable, create `~/.claude/skills/nix-cyberpunk-rice/`:

```
nix-cyberpunk-rice/
├── skill.md              # Skill description
├── assets/
│   ├── configuration.nix # Template config
│   └── dotfiles/         # All rice configs
└── scripts/
    └── apply-rice.sh     # Script to add rice to existing NixOS
```

User workflow:
```bash
# In their NixOS project
claude "Add cyberpunk rice to my NixOS config"
# Skill automatically merges rice configs into their configuration.nix
# Copies dotfiles to their project
# They rebuild and get instant cyberpunk rice
```

## Key Lessons

1. **Embrace determinism**: Use tools like ImageMagick to generate instead of download
2. **Use activation scripts**: Perfect for file operations and setup
3. **Keep it simple**: Don't over-engineer with home-manager if not needed
4. **Test offline**: If it works offline, it's truly reproducible
5. **Version control everything**: All configs in Git

## Why This Matters

**Traditional rice:**
> "My desktop looks cool but I can't recreate it"

**Declarative rice:**
> "My desktop is defined in code. `nix build`, get exact same result, forever."

This is the NixOS way. 🌃
