#!/bin/bash
set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

PACKAGES=(base-devel git hyprland hyprpaper hyprlock swaync rofi-wayland waybar kitty dolphin rust wlogout)

echo -e "${CYAN}[START] Pure-Flow: Starting Arch Linux Installation...${NC}"

total=${#PACKAGES[@]}
count=0

echo "------------------------------------------------------------"
for pkg in "${PACKAGES[@]}"; do
    count=$((count + 1))
    percent=$((count * 100 / total))
    
    printf "\rInstalling: %-30s %3d%%" "$pkg" "$percent"
    echo -e "\nPackage installation details (Downloading...)"
    
    sudo pacman -S --needed --noconfirm "$pkg" > /dev/null 2>&1
    
    printf "\033[1A\033[K\033[1A\033[K" 
done
echo -e "${GREEN}[OK] System packages installed.${NC}"
echo "------------------------------------------------------------"

if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si --noconfirm && cd -
fi
yay -S --noconfirm matugen > /dev/null 2>&1

if [ -d "fonts" ]; then
    echo -e "${CYAN}[INFO] Installing local fonts...${NC}"
    mkdir -p ~/.local/share/fonts
    cp -r fonts/*.{ttf,otf} ~/.local/share/fonts/ 2>/dev/null || cp -r fonts/* ~/.local/share/fonts/
    fc-cache -fv > /dev/null 2>&1
fi

mkdir -p ~/.config
[ -d ~/.config/hypr ] && mv ~/.config/hypr ~/.config/hypr_old_$(date +%Y%m%d_%H%M)
cp -r config/* ~/.config/
chmod +x ~/.config/hypr/scripts/* 2>/dev/null || true

sed -i "s|/home/$USER/|$HOME/|g" ~/.config/hypr/*.conf 2>/dev/null || true

echo -e "${GREEN}[DONE] Pure-Flow installation completed successfully!${NC}"
