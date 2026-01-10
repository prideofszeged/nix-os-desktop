#!/usr/bin/env bash
set -e

echo "Building NixOS Developer VM..."
echo "This may take 10-15 minutes on first build..."

nix build .#vm

echo ""
echo "Build complete!"
echo "Run './run-vm.sh' to start the VM"
