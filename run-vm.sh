#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PERSIST_DIR="/mnt/nvme/nix-vm-persist"

# Parse flags
RESET=false
BUILD=false
HEADLESS=false
RESTART=false
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
        --headless)
            HEADLESS=true
            shift
            ;;
        --restart)
            RESTART=true
            shift
            ;;
        -h|--help)
            echo "Usage: ./run-vm.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --headless Run without display, SSH on port 2222"
            echo "  --restart  Kill running VM before starting"
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

# Handle restart - kill any running VM
if [ "$RESTART" = true ]; then
    QEMU_PID=$(pgrep -f 'qemu-system.*nixos-dev' || true)
    if [ -n "$QEMU_PID" ]; then
        echo "Stopping running VM (PID $QEMU_PID)..."
        kill "$QEMU_PID"
        sleep 2
        # Force kill if still alive
        kill -0 "$QEMU_PID" 2>/dev/null && kill -9 "$QEMU_PID"
        echo "   VM stopped."
    else
        echo "No running VM found."
    fi
fi

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
echo "  Username: dev  |  Password: dev"
echo "  📂 Persistent storage: $PERSIST_DIR → /persist (in VM)"
echo ""

if [ "$HEADLESS" = true ]; then
    echo "📡 Headless mode: SSH on localhost:2222"
    echo "  Connect:  ssh -p 2222 dev@localhost"
    echo "  Shutdown: ssh -p 2222 dev@localhost sudo poweroff"
    echo ""
    QEMU_OPTS="-m 12G -smp 6 -display none -serial mon:stdio" \
    QEMU_NET_OPTS="hostfwd=tcp::2222-:22" \
        ./result/bin/run-nixos-dev-vm
else
    echo "📺 Display: SPICE (remote-viewer on localhost:5930)"
    echo "  Press Ctrl+Alt+G to release mouse from VM"
    echo "  Close the VM window to shut down"
    echo ""
    QEMU_OPTS="-m 12G -smp 6 -display spice-app" \
        ./result/bin/run-nixos-dev-vm
fi
