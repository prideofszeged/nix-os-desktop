#!/usr/bin/env bash
# Manual Claude Code installer

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Manual Claude Code 2.0.64 Installation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check Node.js
echo "Checking Node.js..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found! This shouldn't happen in NixOS."
    exit 1
fi
echo "✅ Node.js $(node --version)"
echo ""

# Check npm
echo "Checking npm..."
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found! This shouldn't happen."
    exit 1
fi
echo "✅ npm $(npm --version)"
echo ""

# Set up npm global directory
echo "Setting up npm global directory..."
mkdir -p $HOME/.npm-global
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"
npm config set prefix "$HOME/.npm-global"
echo "✅ npm prefix set to $HOME/.npm-global"
echo ""

# Install Claude Code using official installer
echo "Installing Claude Code 2.0.64 using official installer..."
curl -fsSL https://claude.ai/install.sh | bash -s -- 2.0.64

# If official installer fails, try npm fallback
if [ ! -f $HOME/.npm-global/bin/claude ]; then
    echo ""
    echo "⚠️  Official installer failed, trying npm fallback..."
    npm install -g @anthropic-ai/claude-code@2.0.64
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Verification"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if installed
if [ -f $HOME/.npm-global/bin/claude ]; then
    echo "✅ Claude Code installed!"
    echo "   Location: $HOME/.npm-global/bin/claude"
    echo ""

    # Add to PATH for current session
    export PATH="$HOME/.npm-global/bin:$PATH"

    # Check version
    if claude --version &> /dev/null; then
        echo "✅ Version: $(claude --version)"
    else
        echo "⚠️  Binary exists but version check failed"
    fi
else
    echo "❌ Claude Code not found at $HOME/.npm-global/bin/claude"
    echo "   Check the npm output above for errors"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Next Steps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Open a new terminal window"
echo "2. Run: claude --version"
echo "3. If not found, check PATH with: echo \$PATH | grep npm-global"
echo ""
