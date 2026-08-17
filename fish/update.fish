#!/usr/bin/env fish

echo "=========================================="
echo "          Arch Linux System Update        "
echo "=========================================="
echo

# Prompt for sudo early
sudo -v; or exit 1

echo "Synchronizing databases and upgrading packages..."
sudo pacman -Syu

echo
echo "Done! Press Enter to close this window..."
read
