#!/usr/bin/env bash
# Quick script to run in VM to check Home Manager status

echo "Checking Home Manager deployment..."
echo ""

echo "1. Home Manager current generation:"
ls -la ~/.local/state/home-manager/gcroots/current-home 2>&1

echo ""
echo "2. Files in ~/.local/:"
ls -la ~/.local/

echo ""
echo "3. Check if our scripts exist in /nix/store:"
find ~/.local/state/home-manager -name "*check-claude*" 2>/dev/null | head -5

echo ""
echo "4. Home Manager profile contents:"
ls -la ~/.nix-profile/bin/ 2>&1 | grep -E "(check-claude|install-claude|debug)" || echo "Scripts not found in profile"

echo ""
echo "5. Check if scripts are in home-files:"
find ~/.local/state/home-manager -name "home-files" -type d 2>/dev/null | while read dir; do
    echo "Checking: $dir"
    find "$dir" -name "*claude*" 2>/dev/null | head -5
done

echo ""
echo "6. Try to create ~/.local/bin manually and copy:"
mkdir -p ~/.local/bin
echo "Created ~/.local/bin"
ls -la ~/.local/

echo ""
echo "7. Check Home Manager activation status:"
systemctl --user status home-manager-dev.service 2>&1 || echo "Service not found"

