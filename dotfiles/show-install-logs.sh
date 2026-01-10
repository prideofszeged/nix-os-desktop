#!/usr/bin/env bash
# Show Claude Code installation logs

echo "════════════════════════════════════════════════════"
echo "Claude Code Installation Logs"
echo "════════════════════════════════════════════════════"
echo ""

echo "1. Home Manager Activation Logs"
echo "────────────────────────────────────────────────────"
if command -v journalctl &> /dev/null; then
    echo "Looking for home-manager service logs..."
    journalctl --user -u "home-manager-*" --no-pager -n 100 2>&1 | grep -A 20 -B 5 "Claude Code" || {
        echo "No Claude Code logs found in home-manager service"
        echo ""
        echo "All home-manager logs:"
        journalctl --user -u "home-manager-*" --no-pager -n 50 2>&1
    }
else
    echo "⚠️  journalctl not available"
fi
echo ""

echo "2. Systemd Claude Code Installer Service"
echo "────────────────────────────────────────────────────"
if systemctl --user list-unit-files | grep -q claude-code-installer; then
    echo "Service status:"
    systemctl --user status claude-code-installer.service 2>&1
    echo ""
    echo "Service logs:"
    journalctl --user -u claude-code-installer.service --no-pager -n 50 2>&1
else
    echo "⚠️  claude-code-installer.service not found"
    echo "Available user services:"
    systemctl --user list-units --type=service 2>&1 | head -20
fi
echo ""

echo "3. Build Output Logs (if available)"
echo "────────────────────────────────────────────────────"
if [ -f /tmp/nix-build.log ]; then
    echo "Found build log:"
    grep -A 30 -B 5 "Claude Code" /tmp/nix-build.log || echo "No Claude Code logs in build output"
else
    echo "No build log found at /tmp/nix-build.log"
fi
echo ""

echo "4. Home Manager Activation Script Output"
echo "────────────────────────────────────────────────────"
echo "Looking for activation script outputs..."
if [ -d ~/.local/state/home-manager ]; then
    find ~/.local/state/home-manager -type f -name "*log*" 2>/dev/null | while read log; do
        echo "Found: $log"
        if grep -q "Claude" "$log" 2>/dev/null; then
            echo "Contents:"
            cat "$log"
        fi
    done
else
    echo "⚠️  Home Manager state directory not found"
fi
echo ""

echo "════════════════════════════════════════════════════"
echo "Tip: Run 'debug-claude-install' for current status"
echo "════════════════════════════════════════════════════"
