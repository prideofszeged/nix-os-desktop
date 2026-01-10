#!/usr/bin/env bash
# Run this INSIDE the VM to check Home Manager status

echo "=== Checking if Home Manager configuration is applied ==="
echo ""

echo "1. Check if any home.nix settings took effect:"
echo "   - GTK theme (should be Arc-Dark):"
cat ~/.config/gtk-3.0/settings.ini 2>&1 | grep gtk-theme-name || echo "   Not found"

echo ""
echo "   - i3 config (should exist):"
ls -lh ~/.config/i3/config 2>&1 || echo "   Not found"

echo ""
echo "   - Polybar config (should exist):"
ls -lh ~/.config/polybar/config.ini 2>&1 || echo "   Not found"

echo ""
echo "2. Check systemd user services:"
systemctl --user list-unit-files 2>&1 | grep -i claude || echo "   No claude services found"

echo ""
echo "3. Check if wallpaper was generated:"
ls -lh ~/.config/wallpapers/cyberpunk.png 2>&1 || echo "   Not generated"

echo ""
echo "4. Check PATH additions:"
echo "   Current PATH:"
echo "$PATH" | tr ':' '\n' | grep -E "(local/bin|npm-global)"

echo ""
echo "5. Check ZSH config:"
echo "   Shell: $SHELL"
echo "   oh-my-zsh installed: $([ -d ~/.oh-my-zsh ] && echo YES || echo NO)"

echo ""
echo "=== Diagnosis ==="
if [ -f ~/.config/i3/config ] && [ -f ~/.config/polybar/config.ini ]; then
    echo "✅ Home Manager IS working (configs are deployed)"
    echo "❌ But scripts in ~/.local/bin/ are missing"
    echo ""
    echo "This means the home.file entries might not be working."
    echo "Let's check the Nix store:"
    ls -la /nix/store/*check-claude* 2>&1 | head -3 || echo "Scripts not in Nix store"
else
    echo "❌ Home Manager is NOT working (no configs deployed)"
    echo ""
    echo "The Home Manager module isn't activating."
    echo "This is a bigger configuration issue."
fi
