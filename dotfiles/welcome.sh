#!/usr/bin/env bash
# CYBERPUNK WELCOME MESSAGE

# Colors
PINK='\033[38;5;198m'
PURPLE='\033[38;5;135m'
CYAN='\033[38;5;51m'
BLUE='\033[38;5;33m'
RESET='\033[0m'

cat << "EOF"
    ▄████▄▓██   ██▓ ▄▄▄▄   ▓█████  ██▀███   ██▓███   █    ██  ███▄    █  ██ ▄█▀
   ▒██▀ ▀█ ▒██  ██▒▓█████▄ ▓█   ▀ ▓██ ▒ ██▒▓██░  ██▒ ██  ▓██▒ ██ ▀█   █  ██▄█▒
   ▒▓█    ▄ ▒██ ██░▒██▒ ▄██▒███   ▓██ ░▄█ ▒▓██░ ██▓▒▓██  ▒██░▓██  ▀█ ██▒▓███▄░
   ▒▓▓▄ ▄██▒░ ▐██▓░▒██░█▀  ▒▓█  ▄ ▒██▀▀█▄  ▒██▄█▓▒ ▒▓▓█  ░██░▓██▒  ▐▌██▒▓██ █▄
   ▒ ▓███▀ ░░ ██▒▓░░▓█  ▀█▓░▒████▒░██▓ ▒██▒▒██▒ ░  ░▒▒█████▓ ▒██░   ▓██░▒██▒ █▄
   ░ ░▒ ▒  ░ ██▒▒▒ ░▒▓███▀▒░░ ▒░ ░░ ▒▓ ░▒▓░▒▓▒░ ░  ░░▒▓▒ ▒ ▒ ░ ▒░   ▒ ▒ ▒ ▒▒ ▓▒
     ░  ▒  ▓██ ░▒░ ▒░▒   ░  ░ ░  ░  ░▒ ░ ▒░░▒ ░     ░░▒░ ░ ░ ░ ░░   ░ ▒░░ ░▒ ▒░
   ░       ▒ ▒ ░░   ░    ░    ░     ░░   ░ ░░        ░░░ ░ ░    ░   ░ ░ ░ ░░ ░
   ░ ░     ░ ░      ░         ░  ░   ░                  ░              ░ ░  ░
   ░       ░ ░           ░
EOF

echo -e "${PINK}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${CYAN}  Welcome to the NixOS Developer Desktop - CYBERPUNK EDITION${RESET}"
echo -e "${PURPLE}  Node $(node --version) | Python $(python --version 2>&1 | cut -d' ' -f2) | Go $(go version | cut -d' ' -f3 | sed 's/go//') | Rust $(rustc --version | cut -d' ' -f2)${RESET}"
echo -e "${BLUE}  Type 'neofetch' for system info | 'cava' for audio visualizer | 'matrix' for fun${RESET}"
echo -e "${PINK}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
