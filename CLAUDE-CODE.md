# Claude Code Setup

## Installation

Claude Code 2.0.64 is automatically installed via Home Manager during VM setup.

### How It Works

1. **Node.js 20** - Pre-installed as system package
2. **npm global directory** - Set to `~/.npm-global` (user-owned)
3. **Claude Code 2.0.64** - Installed via `home.activation.installClaudeCode`
4. **PATH configuration** - Automatically added to shell PATH

### Configuration Location

All Claude Code setup is in `home.nix`:

```nix
# Node.js and npm configuration
home.sessionVariables = {
  NPM_CONFIG_PREFIX = "$HOME/.npm-global";
};

home.sessionPath = [
  "$HOME/.npm-global/bin"
];

# Install Claude Code 2.0.64 via npm
home.activation.installClaudeCode = ''
  mkdir -p $HOME/.npm-global
  ${pkgs.nodejs_20}/bin/npm config set prefix "$HOME/.npm-global"

  if [ ! -f $HOME/.npm-global/bin/claude ] || ! $HOME/.npm-global/bin/claude --version | grep -q "2.0.64"; then
    echo "Installing Claude Code 2.0.64..."
    ${pkgs.nodejs_20}/bin/npm install -g @anthropic-ai/claude-code@2.0.64
  else
    echo "Claude Code 2.0.64 already installed"
  fi
'';
```

## Verification

After VM boots, open a terminal and verify:

```bash
# Check Node.js
node --version
# Should show: v20.x.x

# Check npm
npm --version
# Should show: 10.x.x

# Check Claude Code
claude --version
# Should show: 2.0.64

# Check PATH
which claude
# Should show: /home/dev/.npm-global/bin/claude
```

## Usage

```bash
# Get help
claude --help

# Run Claude Code
claude

# Run with specific model
claude --model sonnet-4

# Check configuration
claude config list
```

## Installation Details

### Why npm global?

We use npm global installation because:
- ✅ Specific version pinning (2.0.64)
- ✅ User-owned directory (no permission issues)
- ✅ Easy to update/rollback
- ✅ Works with Home Manager

### Why not Nix package?

Claude Code isn't in nixpkgs yet, so we:
1. Install Node.js via Nix (reproducible)
2. Install Claude Code via npm (specific version)
3. Manage via Home Manager (declarative)

This is a hybrid approach that works until Claude Code is packaged for Nix.

## Troubleshooting

### Claude command not found

**First, use the diagnostic alias:**
```bash
check-claude
```

This shows:
- Node.js version
- npm version
- Claude version (or NOT FOUND)
- Whether npm-global is in PATH

**Quick fix:**
```bash
# Run the diagnostic script (located in ~/.local/bin/)
check-claude

# Install manually (script in ~/.local/bin/)
install-claude

# Then open a new terminal
```

These scripts are automatically copied to `~/.local/bin/` by Home Manager, which is in your PATH.

**Manual steps:**
```bash
# 1. Check if installed
ls -la ~/.npm-global/bin/claude

# 2. Check PATH
echo $PATH | grep npm-global

# 3. Add to PATH manually (current session only)
export PATH="$HOME/.npm-global/bin:$PATH"

# 4. Try running Claude
claude --version

# 5. If still not found, reinstall
npm install -g @anthropic-ai/claude-code@2.0.64
```

**After rebuild:**
```bash
# The Home Manager activation script should show output like:
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Installing Claude Code 2.0.64...
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ...
# ✅ Claude Code installed successfully!

# If you don't see this during build, the activation script may have failed
```

### Wrong version

```bash
# Check version
claude --version

# Force reinstall specific version
npm uninstall -g @anthropic-ai/claude-code
npm install -g @anthropic-ai/claude-code@2.0.64
```

### Permission errors

Our setup uses `~/.npm-global` which is user-owned, so no permission errors should occur.

If you see permission errors:
```bash
# Check ownership
ls -la ~/.npm-global

# Fix if needed (shouldn't be needed)
chown -R dev:users ~/.npm-global
```

## Updating Claude Code

To update to a newer version:

1. **Edit home.nix**:
   ```nix
   ${pkgs.nodejs_20}/bin/npm install -g @anthropic-ai/claude-code@2.0.65
   ```

2. **Rebuild**:
   ```bash
   ./build-vm.sh
   ./run-vm.sh
   ```

3. **Verify**:
   ```bash
   claude --version
   ```

## Configuration

Claude Code config is stored in:
- `~/.claude/config` - User configuration
- `~/.claude/` - Claude data directory

These are **not** managed by Home Manager, so they persist across rebuilds.

## API Key Setup

To use Claude Code, you need an Anthropic API key:

```bash
# Set API key
claude config set apiKey YOUR_API_KEY_HERE

# Verify
claude config list
```

The API key is stored in `~/.claude/config` and persists.

## Why Version 2.0.64?

We pin to 2.0.64 because:
- ✅ Known stable version
- ✅ Reproducible builds
- ✅ Easy to update when needed
- ✅ Prevents unexpected breakage

## Development Workflow

Typical workflow with Claude Code:

```bash
# Terminal 1: Development
cd ~/my-project
nvim src/main.js

# Terminal 2: Claude Code
claude
# Ask Claude to help with code

# Use Alt+1, Alt+2 to switch between terminals in i3
```

## Future: Native Nix Package

When Claude Code is added to nixpkgs, we can migrate to:

```nix
# Future home.nix
home.packages = [ pkgs.claude-code ];
```

For now, the npm approach works perfectly and is fully declarative via Home Manager.

## Summary

- ✅ **Node.js 20**: System package
- ✅ **npm**: Pre-installed with Node
- ✅ **Claude Code 2.0.64**: Installed via Home Manager activation
- ✅ **PATH**: Automatically configured
- ✅ **Verification**: Shows version on first terminal
- ✅ **Updates**: Edit home.nix and rebuild

Your cyberpunk dev environment is Claude-ready! 🤖
