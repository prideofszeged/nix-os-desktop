#!/usr/bin/env bash
# Quick check script to run INSIDE the VM (paste this in terminal)

echo "=== Quick Claude Code Check ==="
echo ""
echo "1. Node & npm:"
node --version && npm --version || echo "Missing!"
echo ""
echo "2. npm prefix:"
npm config get prefix
echo ""
echo "3. Check ~/.npm-global/bin:"
ls -la ~/.npm-global/bin/ 2>&1 || echo "Directory doesn't exist"
echo ""
echo "4. Check if claude binary exists:"
ls -lh ~/.npm-global/bin/claude 2>&1 || echo "Not found"
echo ""
echo "5. PATH:"
echo $PATH | tr ':' '\n' | grep npm-global || echo "npm-global not in PATH"
echo ""
echo "6. Try running claude:"
if [ -f ~/.npm-global/bin/claude ]; then
    ~/.npm-global/bin/claude --version 2>&1 || echo "Binary exists but won't run"
else
    echo "Binary not found"
fi
echo ""
echo "7. Home Manager files in ~/.local/bin:"
ls -la ~/.local/bin/ 2>&1 || echo "Directory doesn't exist yet"
echo ""
echo "=== Manual Installation Command ==="
echo "curl -fsSL https://claude.ai/install.sh | bash -s -- 2.0.64"
