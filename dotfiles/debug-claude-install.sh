#!/usr/bin/env bash
# Debug script to check Claude Code installation status

echo "════════════════════════════════════════════════════"
echo "Claude Code Installation Debug"
echo "════════════════════════════════════════════════════"
echo ""

echo "1. Environment Check"
echo "────────────────────────────────────────────────────"
echo "Current user: $(whoami)"
echo "Home directory: $HOME"
echo "Current directory: $(pwd)"
echo "PATH: $PATH"
echo ""

echo "2. Node.js & npm Status"
echo "────────────────────────────────────────────────────"
if command -v node &> /dev/null; then
    echo "✅ Node.js: $(node --version)"
    echo "   Location: $(which node)"
else
    echo "❌ Node.js not found"
fi

if command -v npm &> /dev/null; then
    echo "✅ npm: $(npm --version)"
    echo "   Location: $(which npm)"
    echo "   npm prefix: $(npm config get prefix)"
else
    echo "❌ npm not found"
fi
echo ""

echo "3. Claude Code Status"
echo "────────────────────────────────────────────────────"
if [ -f "$HOME/.npm-global/bin/claude" ]; then
    echo "✅ Claude binary exists at: $HOME/.npm-global/bin/claude"
    ls -lh "$HOME/.npm-global/bin/claude"

    # Try to run it
    if "$HOME/.npm-global/bin/claude" --version &> /dev/null; then
        echo "✅ Version: $($HOME/.npm-global/bin/claude --version)"
    else
        echo "⚠️  Binary exists but won't run"
        echo "   Trying to execute: $HOME/.npm-global/bin/claude --version"
        "$HOME/.npm-global/bin/claude" --version 2>&1 || true
    fi
else
    echo "❌ Claude binary NOT FOUND at: $HOME/.npm-global/bin/claude"
fi

if command -v claude &> /dev/null; then
    echo "✅ 'claude' found in PATH"
    echo "   Location: $(which claude)"
else
    echo "❌ 'claude' command not in PATH"
fi
echo ""

echo "4. npm global directory"
echo "────────────────────────────────────────────────────"
if [ -d "$HOME/.npm-global" ]; then
    echo "✅ Directory exists: $HOME/.npm-global"
    ls -la "$HOME/.npm-global/"
    echo ""
    if [ -d "$HOME/.npm-global/bin" ]; then
        echo "Contents of $HOME/.npm-global/bin/:"
        ls -la "$HOME/.npm-global/bin/" 2>&1 || echo "  (empty or error)"
    fi
    echo ""
    if [ -d "$HOME/.npm-global/lib/node_modules" ]; then
        echo "Installed global packages:"
        ls -la "$HOME/.npm-global/lib/node_modules/" 2>&1 || echo "  (empty or error)"
    fi
else
    echo "❌ Directory does not exist: $HOME/.npm-global"
fi
echo ""

echo "5. Systemd User Service Status"
echo "────────────────────────────────────────────────────"
if command -v systemctl &> /dev/null; then
    echo "Checking claude-code-installer.service:"
    systemctl --user status claude-code-installer.service 2>&1 || echo "  Service not found or not running"
    echo ""
    echo "Recent logs:"
    journalctl --user -u claude-code-installer.service -n 20 --no-pager 2>&1 || echo "  No logs available"
else
    echo "⚠️  systemctl not available"
fi
echo ""

echo "6. Home Manager Generations"
echo "────────────────────────────────────────────────────"
if [ -L "$HOME/.local/state/home-manager/gcroots/current-home" ]; then
    echo "Current generation:"
    ls -l "$HOME/.local/state/home-manager/gcroots/current-home"
else
    echo "⚠️  Home Manager current generation not found"
fi
echo ""

echo "7. Installation Attempt Test"
echo "────────────────────────────────────────────────────"
echo "Testing npm install command..."
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"

echo "npm config get prefix: $(npm config get prefix 2>&1)"
echo ""
echo "Attempting test install (this may take a moment)..."
npm list -g @anthropic-ai/claude-code 2>&1 || echo "  Package not installed globally"
echo ""

echo "════════════════════════════════════════════════════"
echo "Debug Complete"
echo "════════════════════════════════════════════════════"
