# TODO - NixOS Developer Desktop VM

## Completed ✅

### Core Setup
- [x] Create NixOS flake configuration
- [x] Configure X11 and i3 window manager
- [x] Add development tools (Node.js, Python, Go, Rust, Claude Code)
- [x] Add build and run scripts
- [x] Create comprehensive README
- [x] Set up automatic dotfiles deployment
- [x] Create CLAUDE.md with architecture and development guidance

### CYBERPUNK RICE 🌃
- [x] Full cyberpunk color scheme (neon pink, purple, cyan)
- [x] Heavy transparency and blur effects
- [x] Riced i3 with thicc borders and neon colors
- [x] Cyberpunk Polybar theme with icons
- [x] Cyberpunk Rofi launcher theme
- [x] Cyberpunk Alacritty terminal theme
- [x] Enhanced Picom with dual kawase blur
- [x] Deterministic wallpaper generation (no downloads!)
- [x] Aesthetic tools (neofetch, cava, lolcat, figlet, cmatrix, pipes, cbonsai)
- [x] Cyberpunk welcome banner
- [x] Created CYBERPUNK.md guide

### HOME MANAGER MIGRATION 🏠
- [x] Added Home Manager to flake.nix
- [x] Created home.nix for user-level config
- [x] Migrated all dotfiles to Home Manager
- [x] Removed old activation scripts
- [x] GTK theme via Home Manager
- [x] ZSH and Git via Home Manager
- [x] Created HOME-MANAGER.md documentation
- [ ] Test Home Manager setup in fresh VM

### CLAUDE CODE SETUP 🤖
- [x] Pinned Claude Code to version 2.0.64
- [x] Moved installation to Home Manager
- [x] Set up npm global directory (~/.npm-global)
- [x] Configured PATH for Claude Code
- [x] Added version verification on terminal startup
- [x] Created CLAUDE-CODE.md documentation
- [x] Updated welcome banner with dev tool versions
- [x] Created diagnostic scripts (check-claude, install-claude)
- [x] Fixed PATH setup for ZSH
- [ ] Test Claude Code installation in VM

### TERMINALS & SHELL ENHANCEMENT 🖥️
- [x] Added Ghostty terminal emulator
- [x] Created Ghostty cyberpunk config
- [x] Enhanced oh-my-zsh with 15+ plugins
- [x] Configured Starship with full cyberpunk theme
- [x] Added keybindings for all three terminals (Alacritty, Ghostty, Kitty)
- [x] Created TERMINALS-AND-SHELL.md documentation
- [ ] Test all terminals in VM

## Optional Enhancements 🚀

### Desktop Environment
- [ ] Add wallpaper collection to dotfiles
- [ ] Configure dunst notification daemon styling
- [ ] Set up additional rofi modes (window switcher, emoji picker)
- [ ] Add screencast/recording tools (OBS, simplescreenrecorder)
- [ ] Configure redshift for eye strain reduction

### Development Tools
- [ ] Add Docker and docker-compose
- [ ] Include Kubernetes tools (kubectl, k9s, helm)
- [ ] Add database clients (PostgreSQL, MySQL, Redis)
- [ ] Include API testing tools (Postman, Insomnia, httpie)
- [ ] Set up language-specific tools:
  - [ ] Node: pnpm, yarn, nvm alternative
  - [ ] Python: poetry, black, pylint
  - [ ] Rust: clippy, rustup components
  - [ ] Go: delve debugger, gopls

### IDE/Editor Setup
- [ ] Pre-configure VS Code extensions
- [ ] Set up Neovim with LSP and plugins
- [ ] Add JetBrains IDE support (optional)

### Terminal Improvements
- [ ] Switch to Zsh with oh-my-zsh or starship
- [ ] Add tmux configuration
- [ ] Set up useful shell aliases
- [ ] Configure git aliases and global gitconfig

### System Utilities
- [ ] Add file managers (thunar, nnn, ranger)
- [ ] Include image viewers and editors (feh, gimp, inkscape)
- [ ] Add PDF viewers (zathura, evince)
- [ ] Set up password manager integration
- [ ] Add clipboard manager (clipmenu, parcellite)

### Networking & Security
- [ ] Configure firewall rules
- [ ] Add VPN client (OpenVPN, WireGuard)
- [ ] Set up SSH key management
- [ ] Add security tools (nmap, wireshark)

### Testing & Next Steps
- [ ] Test VM build on fresh system
- [ ] Test all development tools work correctly
- [ ] Verify Claude Code installation and functionality
- [ ] Test i3 keybindings comprehensively
- [ ] Create backup/snapshot workflow

### Migration to Bare Metal
- [ ] Add bootloader configuration (GRUB/systemd-boot)
- [ ] Create hardware-configuration.nix
- [ ] Set up disk partitioning scheme
- [ ] Configure network manager for WiFi
- [ ] Add power management (TLP, powertop)
- [ ] Set up NVIDIA/AMD GPU drivers if needed
- [ ] Configure dual-boot if needed

### Documentation
- [ ] Add screenshots of the desktop
- [ ] Create video walkthrough
- [ ] Document customization examples
- [ ] Add troubleshooting section expansions

## Known Issues 🐛

- None yet - please test and report!

## Notes 📝

- VM uses 8GB RAM and 4 CPU cores by default
- Auto-login enabled for convenience (VM only!)
- All dotfiles are in the `dotfiles/` directory
- Configuration is fully declarative and reproducible
