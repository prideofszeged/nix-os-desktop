# Wallpaper Customization Guide

## Current Wallpaper

The cyberpunk wallpaper is generated deterministically using ImageMagick in `home.nix`.

### How It's Generated

```nix
home.activation.generateWallpaper = ''
  # Base gradient (dark purple to dark blue)
  gradient:'#1a0a2e-#0f3460'

  # Plasma fractal overlay (purple/pink tones)
  -channel R -evaluate multiply 1.2  # More red
  -channel B -evaluate multiply 1.0  # Full blue
  -modulate 120,180                  # Brightness & saturation

  # Neon glow circles (pink, purple, cyan)
  -fill '#ff0a7822' -draw 'circle 960,540 960,200'   # Pink center
  -fill '#bf00ff22' -draw 'circle 400,300 400,100'   # Purple left
  -fill '#00f5ff22' -draw 'circle 1500,700 1500,500' # Cyan right
'';
```

## Customization Options

### Make It Brighter

Edit `home.nix` and change these values:

```nix
# 1. Brighter base gradient
gradient:'#2a1a4e-#1f5490'  # Lighter purple to blue

# 2. Increase brightness
-modulate 140,180  # Was 120,180 - increase first number

# 3. Stronger neon glows
-fill '#ff0a7844' -draw 'circle 960,540 960,200'  # 44 instead of 22
```

### Make It Darker

```nix
# 1. Darker gradient
gradient:'#0a0a1e-#0a2040'

# 2. Decrease brightness
-modulate 100,150

# 3. Subtle glows
-fill '#ff0a7811' -draw 'circle 960,540 960,200'  # 11 instead of 22
```

### Change Colors

#### Green Matrix Theme
```nix
gradient:'#001a00-#003300'  # Dark green
-channel R -evaluate multiply 0.2
-channel G -evaluate multiply 1.5  # More green
-channel B -evaluate multiply 0.2
-fill '#00ff0022' -draw 'circle 960,540 960,200'  # Green glows
```

#### Blue Tron Theme
```nix
gradient:'#001a33-#003d5c'  # Dark blue
-channel R -evaluate multiply 0.3
-channel G -evaluate multiply 0.8
-channel B -evaluate multiply 1.5  # More blue
-fill '#00ccff33' -draw 'circle 960,540 960,200'  # Blue glows
```

#### Red/Orange Sunset Cyberpunk
```nix
gradient:'#1a0a00-#3d1f00'  # Dark red/orange
-channel R -evaluate multiply 1.5  # More red
-channel G -evaluate multiply 0.6
-channel B -evaluate multiply 0.2
-fill '#ff4d0033' -draw 'circle 960,540 960,200'  # Orange glows
```

### Adjust Neon Glow Positions

The circles are positioned as:
```nix
'circle X,Y X,RADIUS'
```

Example positions:
```nix
# Center large glow
-fill '#ff0a7833' -draw 'circle 960,540 960,300'

# Top-right corner
-fill '#bf00ff22' -draw 'circle 1700,200 1700,100'

# Bottom-left corner
-fill '#00f5ff22' -draw 'circle 220,880 220,100'

# Multiple small glows scattered
-fill '#ff0a7811' -draw 'circle 300,200 300,50'
-fill '#bf00ff11' -draw 'circle 800,800 800,50'
-fill '#00f5ff11' -draw 'circle 1600,400 1600,50'
```

### Remove Glows Entirely

```nix
# Delete or comment out this section:
\( -size 1920x1080 xc:none \
   -fill '#ff0a7822' -draw 'circle 960,540 960,200' \
   -fill '#bf00ff22' -draw 'circle 400,300 400,100' \
   -fill '#00f5ff22' -draw 'circle 1500,700 1500,500' \
   -blur 0x80 \) \
-compose screen -composite \
```

### Add More Plasma Detail

```nix
# Sharper plasma (less blur)
-blur 0x0.5  # Was 0x1

# More fractal detail
-channel R -evaluate multiply 1.5  # More variation
-modulate 120,200  # More saturation
```

## Quick Presets

### Copy-Paste Ready

#### Bright & Vibrant (Current)
```nix
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
```

#### Very Bright (For daytime use)
```nix
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
     -fill '#ff0a7844' -draw 'circle 960,540 960,250' \
     -fill '#bf00ff44' -draw 'circle 400,300 400,150' \
     -fill '#00f5ff44' -draw 'circle 1500,700 1500,200' \
     -blur 0x100 \) \
  -compose screen -composite \
  ~/.config/wallpapers/cyberpunk.png
```

#### Subtle Dark (Original vibe)
```nix
${pkgs.imagemagick}/bin/convert -size 1920x1080 \
  -define gradient:angle=135 \
  gradient:'#0a0e14-#1a1a2e' \
  \( -size 1920x1080 plasma:fractal -colorspace RGB -auto-level \
     -channel R -evaluate multiply 0.8 \
     -channel G -evaluate multiply 0.1 \
     -channel B -evaluate multiply 0.6 \
     +channel -modulate 100,150 \) \
  -compose overlay -composite \
  -blur 0x2 \
  ~/.config/wallpapers/cyberpunk.png
```

## Apply Changes

1. **Edit home.nix**:
   ```bash
   vim home.nix
   # Find home.activation.generateWallpaper
   # Replace with your chosen preset
   ```

2. **Rebuild VM**:
   ```bash
   ./build-vm.sh
   ```

3. **Run VM**:
   ```bash
   ./run-vm.sh
   ```

The new wallpaper will be generated on boot!

## Advanced: Multiple Wallpapers

Create multiple wallpapers and switch between them:

```nix
home.activation.generateWallpapers = ''
  mkdir -p ~/.config/wallpapers

  # Bright version
  ${pkgs.imagemagick}/bin/convert ... ~/.config/wallpapers/bright.png

  # Dark version
  ${pkgs.imagemagick}/bin/convert ... ~/.config/wallpapers/dark.png

  # Matrix version
  ${pkgs.imagemagick}/bin/convert ... ~/.config/wallpapers/matrix.png

  # Default to bright
  ln -sf ~/.config/wallpapers/bright.png ~/.config/wallpaper.png
'';
```

Then switch in the VM:
```bash
feh --bg-scale ~/.config/wallpapers/dark.png
feh --bg-scale ~/.config/wallpapers/matrix.png
```

## Color Reference

### Cyberpunk Palette
```
Neon Pink:   #ff0a78
Neon Purple: #bf00ff
Neon Cyan:   #00f5ff
Neon Blue:   #0066ff
Dark Purple: #1a0a2e
Dark Blue:   #0f3460
Deep Black:  #0a0e14
```

### ImageMagick Tips

- **Gradient angle**: 0=left-to-right, 90=top-to-bottom, 135=diagonal
- **Alpha values**: 00=transparent, FF=opaque, 22=very transparent, 88=semi-transparent
- **Blur strength**: 0x1=slight, 0x50=medium, 0x100=heavy
- **Modulate**: first number=brightness, second=saturation

## Troubleshooting

### Wallpaper not updating
```bash
# In VM, force regenerate:
rm ~/.config/wallpapers/cyberpunk.png
~/.config/rice.sh  # If you kept the script
# Or just logout and login again
```

### Want solid color instead
```nix
home.activation.generateWallpaper = ''
  ${pkgs.imagemagick}/bin/convert -size 1920x1080 \
    xc:'#1a1a2e' \
    ~/.config/wallpapers/cyberpunk.png
'';
```

Enjoy customizing your cyberpunk desktop! 🌃
