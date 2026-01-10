# 🌃 CYBERPUNK RICE GUIDE 🌃

Welcome to your fully riced cyberpunk NixOS desktop! This guide covers all the aesthetic features.

## 🎨 Color Scheme

Your desktop uses a neon cyberpunk palette:
- **Neon Pink**: #ff0a78 (primary accent)
- **Neon Purple**: #bf00ff (secondary accent)
- **Neon Cyan**: #00f5ff (highlights)
- **Neon Blue**: #0066ff (tertiary)
- **Background**: #0a0e14 (deep dark)
- **Super Background**: #1a1a2e (slightly lighter)

## ✨ Visual Features

### Heavy Transparency & Blur
- **Alacritty terminal**: 85% opacity with blur
- **All windows**: Blurred backgrounds for that glass effect
- **Picom compositor**: Dual Kawase blur (strength 8)

### Neon Borders
- **3px thick borders** on all windows
- **Active window**: Neon pink border
- **Inactive windows**: Dark gray
- **Indicator**: Neon purple

### Gaps & Spacing
- **Inner gaps**: 15px (wider than standard)
- **Outer gaps**: 10px
- **Rounded corners**: 12px radius

## 🚀 Aesthetic Tools

### Neofetch
```bash
neofetch
```
Shows system info with cyberpunk colors.

### Cava (Audio Visualizer)
```bash
cava
```
Real-time audio visualizer in your terminal. Play music and watch the bars!

### CMatrix
```bash
cmatrix
```
Matrix-style falling characters. Pure aesthetic.

### Pipes
```bash
pipes
```
Colorful animated pipes in terminal.

### Cbonsai
```bash
cbonsai -l
```
Grow a cyberpunk bonsai tree in your terminal.

### Lolcat
```bash
echo "CYBERPUNK" | lolcat
neofetch | lolcat
```
Rainbow gradient text. Pipe anything through it!

### Figlet
```bash
figlet -f standard "CYBERPUNK" | lolcat
```
ASCII art text generator.

## 🖼️ Wallpapers

The ricer script automatically downloads cyberpunk wallpapers from Unsplash:
- Stored in `~/.config/wallpapers/`
- Random wallpaper set on each login
- Fallback: Gradient from dark to darker cyberpunk colors

### Manual Wallpaper Change
```bash
feh --bg-scale ~/.config/wallpapers/cyberpunk2.jpg
```

## 🎯 Polybar

Your status bar features:
- **Left**: i3 workspaces with icons (󰈹    )
- **Center**: Date/time with neon pink
- **Right**: Filesystem, volume, RAM, CPU, network

All modules use neon colors and icons from Nerd Fonts.

## 🎨 Rofi (App Launcher)

Press `Super + D` to open:
- Semi-transparent dark background
- Neon pink borders (3px)
- Neon cyan prompt
- Selected items highlighted in pink
- Blur effect behind the window

## 🪟 Window Effects

### Shadows
- **20px shadow radius** (large glow effect)
- **Neon pink shadow color** on active windows
- Heavy shadow opacity (0.9)

### Fading
- Windows fade in/out smoothly
- Fade delta: 8 (fast transitions)

## 🔧 Customization

### Change Colors
Edit these files:
- i3: `~/.config/i3/config` (search for "CYBERPUNK Color scheme")
- Polybar: `~/.config/polybar/config.ini` (under `[colors]`)
- Alacritty: `~/.config/alacritty/alacritty.toml`
- Rofi: `~/.config/rofi/cyberpunk.rasi`

### Adjust Transparency
Edit `~/.config/picom/picom.conf`:
```conf
inactive-opacity = 0.85;  # Change this (0.0-1.0)
active-opacity = 0.95;    # And this
blur-strength = 8;        # Blur intensity (0-20)
```

Then restart picom:
```bash
killall picom && picom -b
```

### Add More Blur
Increase `blur-strength` in picom config (max ~20).

### Thicc-er Borders
Edit `~/.config/i3/config`:
```
default_border pixel 3  # Change to 4, 5, etc.
```

Reload i3: `Super + Shift + R`

## 🎵 Audio Visualizer Setup

For cava to work with audio:
1. Play music (Firefox, Spotify, etc.)
2. Run `cava` in terminal
3. Bars should visualize your audio!

Config: `~/.config/cava/config` (auto-generated on first run)

## 📸 Screenshots

- `Print` - Screenshot with Flameshot
- Select area to capture
- Saves to `~/Pictures/`

## 🌟 Pro Tips

### Terminal Bling
```bash
# Welcome message
~/.config/welcome.sh

# System info
neofetch | lolcat

# Matrix effect
cmatrix -b  # Bold characters

# Rainbow pipes
pipes | lolcat
```

### Workspace Icons
Your workspaces use Nerd Font icons:
- 1: 󰈹 (Browser)
- 2:  (Code)
- 3:  (Terminal)
- 4:  (Files)
- 5:  (Music)
- 6-10:  (Gear icon)

### Lock Screen
`Super + Shift + X` - Dark cyberpunk lock screen

## 🔄 Refresh Rice

If something looks off:
```bash
~/.config/rice.sh
```

This re-applies:
- Wallpaper
- GTK theme
- Cursor theme

## 🎨 Theme Variations

Want different vibes? Edit the color scheme in all config files:

**Vaporwave**: Replace pinks with purples and cyans
**Green Matrix**: Use green (#00ff00) as primary
**Blue Tron**: Use blues (#00f5ff, #0080ff)

## 🚀 Performance

The blur and transparency use GPU acceleration:
- Backend: GLX (OpenGL)
- Uses `glx-no-stencil` for performance
- VSync enabled to prevent tearing

If laggy, reduce blur strength or disable blur in picom config.

## 📦 Installed Tools

All aesthetic tools are pre-installed:
- neofetch
- cava
- lolcat
- figlet
- imagemagick (for image manipulation)
- cmatrix
- pipes
- cbonsai

## 🎯 Next Level Rice

Want to go further?

1. **Conky**: System monitor overlay
2. **Tint2**: Superernative panel
3. **Custom Polybar modules**: Weather, Spotify, etc.
4. **Startup music**: Play cyberpunk sounds on login
5. **Custom GTK theme**: Modify Arc-Dark

## 🌈 Enjoy Your Cyberpunk Desktop!

You're now running one of the most aesthetic developer setups possible.

Type `figlet CYBERPUNK | lolcat` to celebrate! 🎉
