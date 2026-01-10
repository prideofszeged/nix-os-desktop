#!/usr/bin/env bash
# CYBERPUNK RICER SCRIPT - Makes your desktop AESTHETIC AF

CONFIG_DIR="$HOME/.config"
WALLPAPER_DIR="$CONFIG_DIR/wallpapers"

echo "🌆 INITIATING CYBERPUNK RICE PROTOCOL..."

# Create wallpaper directory
mkdir -p "$WALLPAPER_DIR"

# Download cyberpunk wallpapers if not already present
if [ ! -f "$WALLPAPER_DIR/cyberpunk1.jpg" ]; then
    echo "📥 Downloading cyberpunk wallpapers..."

    # Cyberpunk city wallpapers (using free sources)
    curl -L "https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=1920" \
        -o "$WALLPAPER_DIR/cyberpunk1.jpg" 2>/dev/null || \
        echo "⚠️  Wallpaper download failed (no internet?)"

    curl -L "https://images.unsplash.com/photo-1519501025264-65ba15a82390?w=1920" \
        -o "$WALLPAPER_DIR/cyberpunk2.jpg" 2>/dev/null

    curl -L "https://images.unsplash.com/photo-1563089145-599997674d42?w=1920" \
        -o "$WALLPAPER_DIR/cyberpunk3.jpg" 2>/dev/null
fi

# Set a random wallpaper or fallback to solid color
if [ -f "$WALLPAPER_DIR/cyberpunk1.jpg" ]; then
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f -name "*.jpg" | shuf -n 1)
    feh --bg-scale "$WALLPAPER"
    ln -sf "$WALLPAPER" "$CONFIG_DIR/wallpaper.png"
    echo "🖼️  Wallpaper set: $WALLPAPER"
else
    # Fallback: Create a gradient background
    echo "🎨 Creating synthetic cyberpunk background..."
    convert -size 1920x1080 gradient:'#0a0e14-#1a1a2e' \
        "$CONFIG_DIR/wallpaper.png" 2>/dev/null || \
        xsetroot -solid '#0a0e14'
fi

# Apply GTK theme
if [ -d "/usr/share/themes/Arc-Dark" ]; then
    echo "🎨 Applying GTK theme..."
    gsettings set org.gnome.desktop.interface gtk-theme "Arc-Dark" 2>/dev/null
    gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark" 2>/dev/null
fi

# Set cursor theme
xsetroot -cursor_name left_ptr

echo "✨ CYBERPUNK RICE ACTIVATED!"
echo "🚀 Your desktop is now A E S T H E T I C"
