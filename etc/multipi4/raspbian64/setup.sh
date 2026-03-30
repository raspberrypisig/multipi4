#!/usr/bin/env bash
set -x

volname="$1"

echo "MODULES=most" > /etc/initramfs-tools/conf.d/multipi4.conf

apt update
apt install -y initramfs-tools btrfs-progs

raspi-config nonint do_configure_keyboard us

echo btrfs >> /etc/initramfs-tools/modules

#VERSION=$(find /lib/modules -name *v8+ -exec basename {} \; )
#mkinitramfs -o /boot/firmware/initramfs-btrfs -v $VERSION

for initrd in /lib/modules/*; do
    VERSION=$(basename "$initrd")
    update-initramfs -c -k "$VERSION"
done

BOOT_DIR="/boot/firmware"
#   [ -d "$BOOT_DIR" ] || BOOT_DIR="/boot"

for initrd in /boot/initrd.img-*; do
    case "$initrd" in
        *-v8)    cp "$initrd" "$BOOT_DIR/initramfs8"      ;;
        *-2712)  cp "$initrd" "$BOOT_DIR/initramfs_2712"  ;;
    esac
done

sed -i "s/PLACEHOLDER/$volname/" /boot/cmdline.txt 
sed -i "s/PLACEHOLDER/$volname/" /etc/fstab

# Disable kernel updates
#apt-mark hold linux-image-arm64 raspberrypi-kernel raspberrypi-bootloader || true
#sudo apt-mark hold libraspberrypi-bin libraspberrypi-dev libraspberrypi-doc libraspberrypi0
#sudo apt-mark hold raspberrypi-bootloader raspberrypi-kernel raspberrypi-kernel-headers

#systemctl disable resize2fs_once
#systemctl disable dphys-swapfile
