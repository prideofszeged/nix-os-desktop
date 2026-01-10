#!/usr/bin/env bash
# Check what's actually in the VM build

echo "=== Checking VM Build Configuration ==="
echo ""

if [ ! -L "result" ]; then
    echo "❌ No 'result' symlink found. Run ./build-vm.sh first."
    exit 1
fi

echo "1. VM result points to:"
ls -la result
realpath result
echo ""

echo "2. Checking for Home Manager in activation scripts:"
if [ -f result/activate ]; then
    echo "   Found activation script"
    grep -i "home-manager" result/activate || echo "   No home-manager references found"
else
    echo "   No activation script at result/activate"
fi
echo ""

echo "3. Checking system activation:"
if [ -f result/bin/run-nixos-dev-vm ]; then
    echo "   ✅ Found VM run script"
else
    echo "   ❌ No run script found"
fi
echo ""

echo "4. Check if our scripts are in the closure:"
nix-store -qR ./result | grep -i "check-claude" || echo "   Scripts not in closure"
echo ""

echo "5. Check if home.nix config is referenced:"
nix-store -qR ./result | grep -i "home.nix" || echo "   home.nix not in closure"
echo ""

echo "6. Check for Home Manager module:"
nix-store -qR ./result | grep -i "home-manager" | head -5 || echo "   No home-manager in closure"
echo ""

echo "=== Suggestion ==="
echo "If Home Manager isn't in the closure, the module might not be loading."
echo "Try rebuilding: ./build-vm.sh"
