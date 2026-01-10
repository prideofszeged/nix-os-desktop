#!/usr/bin/env bash
# Run this INSIDE the VM to manually activate Home Manager

echo "=== Manually Activating Home Manager ==="
echo ""

echo "1. Checking if service exists..."
systemctl --user list-unit-files | grep home-manager || echo "   Service not found in unit files"
echo ""

echo "2. Checking service status..."
systemctl --user status home-manager-dev.service || echo "   Service not active"
echo ""

echo "3. Trying to start the service..."
systemctl --user start home-manager-dev.service
echo "   Exit code: $?"
echo ""

echo "4. Check status after start:"
systemctl --user status home-manager-dev.service
echo ""

echo "5. Check if files appeared in home directory:"
ls -la ~/.local/bin/ 2>&1 || echo "   Still not created"
echo ""

echo "6. If service doesn't exist, manually run Home Manager activation:"
if [ ! -d ~/.local/bin ]; then
    echo "   Trying manual activation..."
    # Find the home-manager generation in /nix/store
    HM_GEN=$(find /nix/store -maxdepth 1 -name "*home-manager-generation" 2>/dev/null | head -1)
    if [ -n "$HM_GEN" ]; then
        echo "   Found: $HM_GEN"
        if [ -f "$HM_GEN/activate" ]; then
            echo "   Running activation script..."
            $HM_GEN/activate
        else
            echo "   No activate script found in generation"
        fi
    else
        echo "   No home-manager-generation found"
    fi
fi
echo ""

echo "7. Final check:"
ls -la ~/.local/bin/ 2>&1
echo ""

if [ -f ~/.local/bin/check-claude ]; then
    echo "✅ SUCCESS! Home Manager is now activated."
    echo "   Run: check-claude"
else
    echo "❌ Still not working. Checking logs:"
    journalctl --user -u home-manager-dev.service --no-pager -n 50
fi
