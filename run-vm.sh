#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PERSIST_DIR="/nvme/nix-vm-persist"

# Parse flags
RESET=false
BUILD=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --reset)
            RESET=true
            shift
            ;;
        --build)
            BUILD=true
            shift
            ;;
        -h|--help)
            echo "Usage: ./run-vm.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --reset    Delete VM disk and start fresh (keeps $PERSIST_DIR)"
            echo "  --build    Rebuild VM before running"
            echo "  -h, --help Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Handle reset
if [ "$RESET" = true ]; then
    echo "🗑️  Resetting VM (deleting disk images)..."
    rm -f "$SCRIPT_DIR"/*.qcow2
    echo "   Disk wiped. Persistent data in $PERSIST_DIR preserved."
    BUILD=true
fi

# Handle build
if [ "$BUILD" = true ] || [ ! -L "result" ]; then
    echo "🔨 Building VM..."
    "$SCRIPT_DIR/build-vm.sh"
fi

# Ensure persist directory exists on host
if [ ! -d "$PERSIST_DIR" ]; then
    echo "📁 Creating persistent storage at $PERSIST_DIR..."
    mkdir -p "$PERSIST_DIR"
    mkdir -p "$PERSIST_DIR/projects"
    mkdir -p "$PERSIST_DIR/ssh"
    mkdir -p "$PERSIST_DIR/claude"
    echo "   Created: projects/, ssh/, claude/"
fi

echo ""
echo "Starting NixOS Developer VM..."
echo ""
echo "VM will open in a new window with:"
echo "  - i3 window manager + snazzy Catppuccin rice"
echo "  - Development tools: Node, Python, Go, Rust, Claude Code"
echo "  - Username: dev"
echo "  - Password: dev"
echo ""
echo "📂 Persistent storage: $PERSIST_DIR → /persist (in VM)"
echo "📺 Display: SPICE (remote-viewer on localhost:5930)"
echo ""
echo "Press Ctrl+Alt+G to release mouse from VM"
echo "Close the VM window to shut down"
echo ""

# Run the VM with shared folder
# virtfs for sharing host directory with guest
QEMU_OPTS="-m 12G -smp 6 -virtfs local,path=$PERSIST_DIR,mount_tag=persist,security_model=mapped-xattr,id=persist" \
    ./result/bin/run-nixos-dev-vm
