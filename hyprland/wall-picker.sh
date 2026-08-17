#!/bin/bash
WALL_DIR="$HOME/Downloads"

# Use the -d flag to force otter-launcher into "Selection Mode"
selected=$(ls "$WALL_DIR" | grep -E ".jpg$|.png$|.webp$|.jpeg$" | otter-launcher -d)

if [ -n "$selected" ]; then
    awww img "$WALL_DIR/$selected" --transition-type outer --transition-fps 60
fi
