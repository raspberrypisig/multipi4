#!/usr/bin/env bash
set -x
sudo apt update
sudo apt install -y yad git gnome-terminal btrfs-progs

sudo rm -rf /tmp/multipi4

cd /tmp
git clone -b dev https://github.com/raspberrypisig/multipi4
cd multipi4
sudo cp {multipi4,multipi4-gui,multipi4-preparedisk} /usr/local/bin
sudo rsync -av etc/ /etc

mkdir -p ~/.local/share/{icons,applications}
APP=/usr/local/bin/multipi4-gui
ICON=~/.local/share/icons/multipi4.png

cp multipi4.png $ICON

echo "[Desktop Entry]
Name=MultiPi4
Comment=MultiBoot Raspberry Pi 4
Exec=/usr/bin/sudo DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY ${APP}
Icon=${ICON}
Terminal=false
Type=Application
Categories=Utility;" > ~/.local/share/applications/pi-apps.desktop

sudo rm -rf /tmp/multipi4

echo "---------------------------------------------
INSTALLATION COMPLETE.
---------------------------------------------------

You can now open MultiPi4 using Menu->Accessories->MultiPi4
" 



