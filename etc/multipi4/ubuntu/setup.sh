#!/usr/bin/env bash
set -x

volname="$1"

touch /etc/cloud/cloud-init.disabled

echo btrfs >> /etc/initramfs-tools/modules

echo "RESUME=none" > /etc/initramfs-tools/conf.d/resume
update-initramfs -c -k all

if [ -f /boot/firmware/current/cmdline.txt ]; then
  sed -i "s/PLACEHOLDER/$volname/" /boot/firmware/current/cmdline.txt
else
  sed -i "s/PLACEHOLDER/$volname/" /boot/firmware/cmdline.txt
fi

#sed -i "s/PLACEHOLDER/$volname/" /boot/firmware/cmdline.txt 
sed -i "s/PLACEHOLDER/$volname/" /etc/fstab

useradd -G sudo -s /bin/bash -d /home/pi -m pi
echo "pi:raspberry" | chpasswd
echo "pi ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/010_pi-nopasswd
chmod 0440 /etc/sudoers.d/010_pi-nopasswd

