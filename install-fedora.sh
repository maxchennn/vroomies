#!/bin/bash
set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${CYAN}🌌 Pure-Flow: Starting Fedora Installation...${NC}"

sudo dnf copr enable -y solopasha/hyprland
sudo dnf copr enable -y purian23/matugen

sudo dnf install -y hyprland hyprpaper swaync matugen rofi waybar kitty dolphin google-noto-cjk-fonts jetbrains-mono-fonts-all

mkdir -p ~/.config

if [ -d ~/.config/hypr ]; then
    mv ~/.config/hypr ~/.config/hypr_old_$(date +%Y%m%d)
fi

cp -r config/* ~/.config/
chmod +x ~/.config/hypr/scripts/* 2>/dev/null || true

sed -i "s|/home/$USER/|$HOME/|g" ~/.config/hypr/hyprpaper.conf 2>/dev/null || true
sed -i "s|/home/$USER/|$HOME/|g" ~/.config/hypr/hyprland.conf 2>/dev/null || true

echo -e "${GREEN}✨ Installation complete! Pure-Flow is ready.${NC}"
