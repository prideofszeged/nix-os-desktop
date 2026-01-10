#!/usr/bin/env bash
set -e

if [ ! -L "result" ]; then
    echo "VM not built yet. Run './build-vm.sh' first."
    exit 1
fi

echo "Starting NixOS Developer VM..."
echo ""
echo "VM will open in a new window with:"
echo "  - i3 window manager + snazzy Catppuccin rice"
echo "  - Development tools: Node, Python, Go, Rust, Claude Code"
echo "  - Username: dev"
echo "  - Password: dev"
echo ""
echo "📺 Display options:"
echo "  Default: SDL window (current)"
echo "  SPICE:   Connect with 'remote-viewer spice://localhost:5930'"
echo ""
echo "Press Ctrl+Alt+G to release mouse from VM"
echo "Close the VM window to shut down"
echo ""

# Run the VM with SPICE enabled
# Use SDL for the local window, SPICE is also available on port 5930
QEMU_OPTS="-m 8G -smp 4 -display sdl" ./result/bin/run-nixos-dev-vm
