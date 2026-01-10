#!/usr/bin/env bash
set -e

if [ ! -L "result" ]; then
    echo "VM not built yet. Run './build-vm.sh' first."
    exit 1
fi

echo "Starting NixOS Developer VM..."
echo ""
echo "VM will open in a new window with:"
echo "  - i3 window manager"
echo "  - Development tools: Node, Python, Go, Rust, Claude Code"
echo "  - Username: dev"
echo "  - Password: dev"
echo ""
echo "Press Ctrl+Alt+G to release mouse from VM"
echo "Close the VM window to shut down"
echo ""

# Run the VM
# Use SDL or GTK without OpenGL for better compatibility
QEMU_OPTS="-m 8G -smp 4 -display sdl" ./result/bin/run-nixos-dev-vm
