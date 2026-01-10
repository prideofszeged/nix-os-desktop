#!/usr/bin/env bash
# Generate a deterministic cyberpunk wallpaper

OUTPUT="$1"

convert -size 1920x1080 \
  -define gradient:angle=135 \
  gradient:'#0a0e14-#1a1a2e' \
  \( -size 1920x1080 plasma:fractal -colorspace RGB -auto-level \
     -channel R -evaluate multiply 0.8 \
     -channel G -evaluate multiply 0.1 \
     -channel B -evaluate multiply 0.6 \
     +channel -modulate 100,150 \) \
  -compose overlay -composite \
  -blur 0x2 \
  "$OUTPUT"
