# Debugging Claude Code Installation

This guide helps troubleshoot Claude Code installation issues.

## Quick Diagnostic Commands

Run these in the VM after boot:

```bash
# Full diagnostic report (most comprehensive)
debug-claude-install

# Quick status check
check-claude

# View installation logs
show-install-logs

# Manual installation
install-claude
```

## Where Does Installation Run?

### 1. Home Manager Activation Script

**Location:** `home.nix` line 274 (`home.activation.installClaudeCode`)

**When:** During `nixos-rebuild` or VM build

**Runs as:** User `dev` (not root)

**Working directory:** Usually `/` or `/home/dev`

**Logs:** Check with:
```bash
journalctl --user -u "home-manager-*" --no-pager | grep "Claude Code"
```

**What it does:**
1. Creates `~/.npm-global` directory
2. Configures npm prefix
3. Runs official installer: `curl -fsSL https://claude.ai/install.sh | bash -s -- 2.0.64`
4. Falls back to npm if official installer fails
5. Verifies installation

### 2. Systemd User Service

**Location:** `home.nix` line 344 (`systemd.user.services.claude-code-installer`)

**When:** On first boot after network is available

**Status:** Check with:
```bash
systemctl --user status claude-code-installer.service
```

**Logs:** View with:
```bash
journalctl --user -u claude-code-installer.service
```

**What it does:**
- Only runs if `~/.npm-global/bin/claude` doesn't exist
- Waits for network connectivity
- Runs the official installer
- Only executes once (RemainAfterExit=true)

## Common Issues

### Issue 1: "Claude command not found"

**Diagnosis:**
```bash
debug-claude-install
```

**Possible causes:**
1. Installation script failed during build
2. PATH not configured correctly
3. npm global directory not writable
4. Network issues during installation

**Solution:**
```bash
# Try manual installation
install-claude

# Check if it worked
claude --version

# If still not found, check PATH
echo $PATH | grep npm-global
```

### Issue 2: Binary exists but won't run

**Diagnosis:**
```bash
ls -lh ~/.npm-global/bin/claude
~/.npm-global/bin/claude --version
```

**Possible causes:**
1. Binary permissions incorrect
2. Node.js not in PATH
3. Corrupted installation

**Solution:**
```bash
# Check permissions
chmod +x ~/.npm-global/bin/claude

# Reinstall
npm uninstall -g @anthropic-ai/claude-code
npm install -g @anthropic-ai/claude-code@2.0.64
```

### Issue 3: Installation runs but fails

**Diagnosis:**
```bash
show-install-logs
```

**Check for:**
- Network errors (curl failed)
- npm errors (permission denied, package not found)
- npm version conflicts

**Solution:**
```bash
# Check npm configuration
npm config get prefix
# Should be: /home/dev/.npm-global

# Fix if wrong
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
npm config set prefix "$HOME/.npm-global"

# Try installing again
install-claude
```

### Issue 4: Installation script doesn't run at all

**Diagnosis:**
```bash
# Check if Home Manager activation ran
journalctl --user -u "home-manager-*" --no-pager

# Check systemd service
systemctl --user list-units | grep claude
```

**Possible causes:**
- Home Manager activation script syntax error
- Service not enabled properly
- Service failed to start

**Solution:**
Rebuild the VM and watch build output:
```bash
./build-vm.sh 2>&1 | tee /tmp/build.log
grep -i "claude" /tmp/build.log
```

## Build-Time Logs

### Viewing Build Logs

During VM build, watch for Claude Code installation:

```bash
# Build with verbose output
./build-vm.sh 2>&1 | tee build.log

# Search for Claude Code messages
grep -A 20 "Installing Claude Code" build.log
```

### Home Manager Activation Output

The activation script has verbose logging enabled (`set -x`), so you'll see:

```
+ echo Installing Claude Code 2.0.64...
+ whoami
dev
+ echo HOME: /home/dev
+ mkdir -p /home/dev/.npm-global
+ export NPM_CONFIG_PREFIX=/home/dev/.npm-global
...
```

If you don't see this output, the activation script might not be running.

## Manual Installation Methods

### Method 1: Official Installer

```bash
curl -fsSL https://claude.ai/install.sh | bash -s -- 2.0.64
```

### Method 2: npm Direct Install

```bash
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"
npm config set prefix "$HOME/.npm-global"
npm install -g @anthropic-ai/claude-code@2.0.64
```

### Method 3: Using provided script

```bash
install-claude
```

## Verification Steps

After any installation attempt:

```bash
# 1. Check binary exists
ls -lh ~/.npm-global/bin/claude

# 2. Check it's executable
file ~/.npm-global/bin/claude

# 3. Check PATH includes npm-global
echo $PATH | grep npm-global

# 4. Try running it
~/.npm-global/bin/claude --version

# 5. Try via PATH
claude --version
```

## Getting Help

If still having issues, run this and share the output:

```bash
debug-claude-install > /tmp/claude-debug.txt 2>&1
show-install-logs >> /tmp/claude-debug.txt 2>&1
cat /tmp/claude-debug.txt
```

This comprehensive debug output will show:
- Environment status
- Node.js and npm versions
- Claude Code binary location
- PATH configuration
- Installation logs
- Systemd service status
- Home Manager state

## Understanding the Activation Process

Home Manager activation scripts run in this order:

1. `writeBoundary` - Writes files to home directory
2. **Our script** (`entryAfter ["writeBoundary"]`) - Runs after files are written
3. Other activation scripts

Our script runs as the user (`dev`), not root, so it has full access to:
- `$HOME` (`/home/dev`)
- npm configuration
- User-writable directories

The script output goes to the build log, but activation scripts don't normally fail the build even if they error.

## Next Steps

1. Build VM with logs: `./build-vm.sh 2>&1 | tee build.log`
2. Boot VM: `./run-vm.sh`
3. Check status: `debug-claude-install`
4. Review logs: `show-install-logs`
5. Try manual install if needed: `install-claude`
