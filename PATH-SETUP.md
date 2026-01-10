# PATH Setup Explanation

## How PATH is Configured

The VM sets up PATH in multiple ways to ensure everything works:

### 1. Home Manager sessionPath

In `home.nix`:
```nix
home.sessionPath = [
  "$HOME/.local/bin"        # Our scripts (check-claude, install-claude)
  "$HOME/.npm-global/bin"   # npm global packages (Claude Code)
];
```

Home Manager automatically adds these to your PATH via your shell profile.

### 2. ZSH initExtra (Explicit)

In `home.nix`, ZSH config:
```bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
```

This is redundant with `sessionPath` but ensures it works even if something goes wrong.

### 3. npm Configuration

```nix
home.sessionVariables = {
  NPM_CONFIG_PREFIX = "$HOME/.npm-global";
};
```

Tells npm to install global packages to `~/.npm-global/` instead of system-wide.

## Directory Structure

```
~/.local/bin/
├── check-claude       # Diagnostic script
└── install-claude     # Manual installer

~/.npm-global/bin/
└── claude             # Claude Code binary (installed by npm)
```

Both directories are in PATH, so you can run:
- `check-claude` (from ~/.local/bin/)
- `install-claude` (from ~/.local/bin/)
- `claude` (from ~/.npm-global/bin/)

## Verification

In the VM, check your PATH:

```bash
echo $PATH
```

Should show (among other things):
```
/home/dev/.local/bin:/home/dev/.npm-global/bin:...
```

## Debugging PATH Issues

### Check if directories are in PATH

```bash
echo $PATH | tr ':' '\n' | grep -E '(local|npm-global)'
```

Should show:
```
/home/dev/.local/bin
/home/dev/.npm-global/bin
```

### Check if scripts exist

```bash
ls -la ~/.local/bin/
```

Should show:
```
check-claude
install-claude
```

### Check if Claude binary exists

```bash
ls -la ~/.npm-global/bin/
```

Should show:
```
claude
```

### Manual PATH fix (temporary)

If PATH is not set correctly in current shell:
```bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
```

Then try:
```bash
check-claude
claude --version
```

## How It Works

1. **Home Manager builds the VM**
   - Copies `check-claude` → `~/.local/bin/check-claude`
   - Copies `install-claude` → `~/.local/bin/install-claude`
   - Sets `home.sessionPath` in shell profile

2. **Activation script runs**
   - Installs Claude Code via npm
   - Binary goes to `~/.npm-global/bin/claude`

3. **You log in**
   - ZSH sources profile (sets PATH from sessionPath)
   - ZSH runs initExtra (sets PATH explicitly)
   - Both `~/.local/bin/` and `~/.npm-global/bin/` are in PATH

4. **Commands work**
   - `check-claude` → runs from `~/.local/bin/check-claude`
   - `claude` → runs from `~/.npm-global/bin/claude`

## Troubleshooting

### Scripts not found

```bash
# Check if Home Manager copied them
ls -la ~/.local/bin/

# If empty, Home Manager activation may have failed
# Rebuild the VM
```

### Claude not found but scripts work

```bash
# Run diagnostic
check-claude

# This will show if Claude binary exists but PATH is wrong
# Or if Claude installation failed
```

### PATH not persisting

```bash
# Check your shell
echo $SHELL

# Should be: /run/current-system/sw/bin/zsh

# Check ZSH config loaded
grep "npm-global" ~/.zshrc

# Should show the export PATH line
```

## Why Two PATH Methods?

We use both `home.sessionPath` and explicit `export` in ZSH:

1. **sessionPath** - The "proper" Home Manager way
   - Writes to shell profile
   - Clean and declarative

2. **export in initExtra** - The "insurance" method
   - Runs every time ZSH starts
   - Ensures PATH is set even if profile doesn't load correctly

Both should work, but having both ensures maximum compatibility.

## File Locations

### Source (in your project)
```
dotfiles/
├── check-claude.sh     → Copied to ~/.local/bin/check-claude
└── install-claude.sh   → Copied to ~/.local/bin/install-claude
```

### Destination (in VM)
```
~/.local/bin/
├── check-claude        (executable)
└── install-claude      (executable)

~/.npm-global/bin/
└── claude              (installed by npm)
```

All managed declaratively by Home Manager! 🏠
