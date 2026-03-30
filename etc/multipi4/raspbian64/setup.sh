#!/usr/bin/env bash
set -x

volname="$1"

echo "MODULES=most" > /etc/initramfs-tools/conf.d/multipi4.conf

apt update
apt install -y initramfs-tools btrfs-progs

raspi-config nonint do_configure_keyboard us

echo btrfs >> /etc/initramfs-tools/modules

#VERSION=$(find /lib/modules -name *v8+ -exec basename {} \; )
#mkinitramfs -o /boot/initramfs-btrfs -v $VERSION
update-initramfs -u -k all

# if [ -d "/boot/firmware" ]; then
#     BOOT_DIR="/boot/firmware"
    
#     # Raspberry Pi OS auto-generates initramfs8 (for Pi4) or initramfs_2712 (for Pi5)
#     # We copy it to match what MultiPi4's config.txt expects.
#     if [ -f "$BOOT_DIR/initramfs8" ]; then
#         cp "$BOOT_DIR/initramfs8" "$BOOT_DIR/initramfs-btrfs"
#     elif [ -f "$BOOT_DIR/initramfs_2712" ]; then
#         cp "$BOOT_DIR/initramfs_2712" "$BOOT_DIR/initramfs-btrfs"
#     else
#         # Fallback just in case
#         LATEST_INITRD=$(ls -S /boot/initrd.img-* | head -n 1)
#         cp "$LATEST_INITRD" "$BOOT_DIR/initramfs-btrfs"
#     fi
# else
#     BOOT_DIR="/boot"
#     LATEST_INITRD=$(ls -S /boot/initrd.img-* | head -n 1)
#     cp "$LATEST_INITRD" "$BOOT_DIR/initramfs-btrfs"
# fi


sed -i "s/PLACEHOLDER/$volname/" /boot/cmdline.txt 
sed -i "s/PLACEHOLDER/$volname/" /etc/fstab

# Disable kernel updates
#apt-mark hold linux-image-arm64 raspberrypi-kernel raspberrypi-bootloader || true
#sudo apt-mark hold libraspberrypi-bin libraspberrypi-dev libraspberrypi-doc libraspberrypi0
#sudo apt-mark hold raspberrypi-bootloader raspberrypi-kernel raspberrypi-kernel-headers

#systemctl disable resize2fs_once
#systemctl disable dphys-swapfile
