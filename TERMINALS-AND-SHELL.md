# Terminals and Shell Configuration

## Terminals

You have **three** GPU-accelerated terminals, all with cyberpunk themes:

### Alacritty (Default)
- **Launch**: `Super + Enter`
- **Config**: `~/.config/alacritty/alacritty.toml`
- **Features**:
  - 85% opacity with blur
  - Cyberpunk color scheme
  - Fast and minimal
  - Good for everyday use

### Ghostty (Modern)
- **Launch**: `Super + Shift + Enter`
- **Config**: `~/.config/ghostty/config`
- **Features**:
  - 85% opacity with 20px blur
  - Latest GPU rendering
  - Shell integration (cursor, sudo, title)
  - Great for intensive tasks

### Kitty (Feature-rich)
- **Launch**: `Super + Ctrl + Enter`
- **Config**: System default (can be customized)
- **Features**:
  - Split panes
  - Image display
  - Advanced features

## Shell: ZSH with oh-my-zsh

### Configured Plugins

**Version Control**:
- `git` - Git aliases and completion
- `gitignore` - gitignore.io integration

**Languages & Tools**:
- `docker` & `docker-compose` - Docker completion
- `kubectl` - Kubernetes completion
- `python` - Python utilities
- `rust` - Rust utilities
- `golang` - Go utilities
- `npm` & `node` - Node.js utilities

**Utilities**:
- `sudo` - Press ESC twice to prepend sudo
- `history` - Better history search
- `colored-man-pages` - Colorized man pages
- `command-not-found` - Suggests package for missing commands
- `extract` - Smart archive extraction (`extract file.zip`)

### Useful Aliases

From oh-my-zsh plugins:

```bash
# Git (from git plugin)
g         # git
ga        # git add
gc        # git commit
gp        # git push
gl        # git pull
gst       # git status
gco       # git checkout
gcb       # git checkout -b
glog      # git log --oneline --graph

# Docker (from docker plugin)
dps       # docker ps
dpa       # docker ps -a
di        # docker images
drm       # docker rm
drmi      # docker rmi

# Custom aliases (from home.nix)
ll        # ls -lah
..        # cd ..
...       # cd ../..
nf        # neofetch
matrix    # cmatrix -b
```

## Starship Prompt

### Cyberpunk Theme

Your prompt is powered by Starship with custom cyberpunk colors:

```
  ~/projects/myapp  main +2 ~1  17:42
```

**Color scheme**:
- `` (prompt character) - Neon cyan (#00f5ff)
- Directory path - Neon purple (#bf00ff)
- Git branch - Neon cyan (#00f5ff)
- Git status - Neon pink (#ff0a78)
- Language icons - Various neon colors
- Time - Gray (#888888)

### Features

1. **Smart prompt character**:
   - `` - Command succeeded (cyan)
   - `` - Command failed (pink)
   - `` - Vim mode (purple)

2. **Git integration**:
   -  - Branch indicator
   - +n - Staged files
   - ~n - Modified files
   - ?n - Untracked files
   - ⇡n/⇣n - Ahead/behind remote

3. **Language detection**:
   - Automatically shows:
     -  Node.js version (in Node projects)
     -  Python version (in Python projects)
     -  Rust version (in Rust projects)
     -  Go version (in Go projects)

4. **Command duration**:
   - Shows execution time for commands > 500ms
   - `took 2.3s` in yellow

5. **Current time**:
   - Always shows in prompt
   - 24-hour format

## ZSH Features

### Tab Completion

```bash
# Smart completion
git c<TAB>         # Shows: checkout, commit, cherry-pick, etc.
docker r<TAB>      # Shows: run, rm, restart, etc.
npm i<TAB>         # Shows: install, init, etc.

# Path completion
cd /h/d/p<TAB>     # Expands to: /home/dev/projects/
```

### History Search

```bash
# Ctrl+R - Reverse search
# Type part of command, press Ctrl+R repeatedly to cycle

# Up/Down arrows
# Smart search based on what you've typed
```

### Oh-My-Zsh Magic

**Sudo trick**:
```bash
# Typed a command without sudo?
apt install package
# Press ESC ESC
# Becomes: sudo apt install package
```

**Extract archives**:
```bash
extract file.tar.gz    # Automatically detects and extracts
extract file.zip
extract file.7z
```

**Colored man pages**:
```bash
man ls    # Now with colors!
```

## Terminal Comparison

| Feature | Alacritty | Ghostty | Kitty |
|---------|-----------|---------|-------|
| Speed | ⚡⚡⚡ | ⚡⚡⚡ | ⚡⚡ |
| GPU Acceleration | ✅ | ✅ | ✅ |
| Config Format | TOML | Plain | Conf |
| Image Display | ❌ | ❌ | ✅ |
| Split Panes | ❌ | ❌ | ✅ |
| Blur | ✅ | ✅ | ❌ |
| Shell Integration | Basic | Advanced | Advanced |
| Use Case | Daily driver | Modern tasks | Power user |

## Customization

### Change Default Terminal

Edit `dotfiles/i3/config-cyberpunk`:
```bash
# Change the default (Super+Enter)
bindsym $mod+Return exec ghostty    # or kitty
```

### Customize Starship Colors

Edit `home.nix`:
```nix
programs.starship = {
  settings = {
    character = {
      success_symbol = "[➜](bold green)";  # Change to green arrow
    };
    directory = {
      style = "bold cyan";  # Change directory color
    };
  };
};
```

### Add More oh-my-zsh Plugins

Edit `home.nix`:
```nix
oh-my-zsh = {
  plugins = [
    "git"
    "docker"
    # Add more:
    "tmux"
    "virtualenv"
    "terraform"
    # etc.
  ];
};
```

See available plugins: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins

### Customize Terminal Opacity

**Alacritty** (`dotfiles/alacritty/alacritty-cyberpunk.toml`):
```toml
[window]
opacity = 0.95    # Change from 0.85
```

**Ghostty** (`dotfiles/ghostty/config`):
```
background-opacity = 0.95    # Change from 0.85
background-blur-radius = 30  # More blur
```

## Tips & Tricks

### Terminal Multiplexing

Use i3's workspace system instead of tmux:
- `Super + 1-9` - Switch workspaces
- `Super + Shift + 1-9` - Move window to workspace
- Multiple terminals in different workspaces!

### Quick Commands

```bash
# System info
neofetch           # or 'nf'

# Matrix effect
cmatrix -b         # or 'matrix'

# Audio visualizer
cava

# Check tools
check-claude       # Diagnose Claude Code
node --version     # Node.js version
python --version   # Python version
```

### ZSH Power User

```bash
# Glob patterns
ls **/*.js         # All JS files recursively
rm *.{log,tmp}     # Remove .log and .tmp files

# Quick directory navigation
cd -               # Go to previous directory
dirs -v            # Show directory stack

# Suffix aliases (oh-my-zsh does this)
file.pdf           # Opens in PDF viewer
image.png          # Opens in image viewer
```

## Shell Initialization

What happens when you open a terminal:

1. ZSH starts
2. Home Manager profile loads
   - Sets PATH (`~/.local/bin`, `~/.npm-global/bin`)
   - Sets environment variables
3. oh-my-zsh initializes
   - Loads all plugins
   - Sets up completions
4. Starship initializes
   - Detects current directory
   - Shows custom prompt
5. Welcome banner displays
   - Cyberpunk ASCII art
   - Tool versions
   - Claude Code status

## Starship Modules

Enabled modules in your setup:
- `character` - Prompt symbol
- `directory` - Current directory
- `git_branch` - Git branch
- `git_status` - Git changes
- `nodejs` - Node.js version (when detected)
- `python` - Python version (when detected)
- `rust` - Rust version (when detected)
- `golang` - Go version (when detected)
- `cmd_duration` - Command execution time
- `time` - Current time

All with custom cyberpunk colors! 🌃

## Troubleshooting

### Starship not showing

```bash
# Check if enabled
starship --version

# Manually initialize
eval "$(starship init zsh)"
```

### oh-my-zsh not loading

```bash
# Check if installed
ls ~/.oh-my-zsh

# Check ZSH config
cat ~/.zshrc | grep oh-my-zsh
```

### Terminal colors wrong

```bash
# Check $TERM
echo $TERM
# Should be: alacritty or xterm-256color

# Force 256 colors
export TERM=xterm-256color
```

Enjoy your cyberpunk shell experience! ⚡
