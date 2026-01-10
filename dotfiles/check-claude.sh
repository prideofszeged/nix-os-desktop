#!/usr/bin/env bash
# Diagnostic script for Claude Code installation

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Claude Code Diagnostic Check"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check Node.js
echo "Node.js:"
if command -v node &> /dev/null; then
    echo "  ✅ $(node --version)"
else
    echo "  ❌ NOT FOUND"
fi
echo ""

# Check npm
echo "npm:"
if command -v npm &> /dev/null; then
    echo "  ✅ $(npm --version)"
else
    echo "  ❌ NOT FOUND"
fi
echo ""

# Check Claude
echo "Claude Code:"
if command -v claude &> /dev/null; then
    echo "  ✅ $(claude --version)"
    echo "  Location: $(which claude)"
else
    echo "  ❌ NOT FOUND"
    if [ -f "$HOME/.npm-global/bin/claude" ]; then
        echo "  ⚠️  Binary exists at $HOME/.npm-global/bin/claude"
        echo "     but is not in PATH!"
    fi
fi
echo ""

# Check PATH
echo "PATH check:"
if echo "$PATH" | grep -q "npm-global"; then
    echo "  ✅ npm-global is in PATH"
    echo "  PATH entries with npm-global:"
    echo "$PATH" | tr ':' '\n' | grep npm-global | sed 's/^/    /'
else
    echo "  ❌ npm-global NOT in PATH"
    echo "  Current PATH:"
    echo "$PATH" | tr ':' '\n' | sed 's/^/    /'
fi
echo ""

# Check npm global directory
echo "npm global directory:"
echo "  ~/.npm-global/bin exists: $([ -d "$HOME/.npm-global/bin" ] && echo "✅ YES" || echo "❌ NO")"
if [ -d "$HOME/.npm-global/bin" ]; then
    echo "  Contents:"
    ls -la "$HOME/.npm-global/bin" | sed 's/^/    /'
fi
echo ""

# Check npm config
echo "npm config:"
npm_prefix=$(npm config get prefix 2>/dev/null)
echo "  npm prefix: $npm_prefix"
if [ "$npm_prefix" = "$HOME/.npm-global" ]; then
    echo "  ✅ Correctly set to $HOME/.npm-global"
else
    echo "  ⚠️  Expected $HOME/.npm-global, got $npm_prefix"
fi
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Quick Fix:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "If Claude not found but binary exists:"
echo "  export PATH=\"\$HOME/.npm-global/bin:\$PATH\""
echo "  claude --version"
echo ""
echo "To reinstall Claude Code:"
echo "  ~/.config/install-claude.sh"
echo ""
