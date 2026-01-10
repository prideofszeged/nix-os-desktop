.PHONY: all build run clean fresh help

# Default target
all: build

# Build the VM
build:
	@echo "Building NixOS VM..."
	nix build .#vm

# Run the VM (assumes it's already built)
run:
	@./run-vm.sh

# Clean the VM disk image
clean:
	@echo "Removing VM disk image..."
	@rm -f nixos-dev.qcow2
	@echo "VM disk removed."

# Fresh build: clean, rebuild, and run
fresh: clean build run

# Show help
help:
	@echo "NixOS VM Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make build   - Build the VM"
	@echo "  make run     - Run the VM"
	@echo "  make clean   - Remove the VM disk image"
	@echo "  make fresh   - Clean, rebuild, and run (recommended)"
	@echo "  make help    - Show this help message"
