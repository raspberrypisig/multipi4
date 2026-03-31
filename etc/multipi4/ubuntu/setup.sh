#!/usr/bin/env bash
set -x

volname="$1"

#mv /etc/resolv.conf /etc/resolv.conf.old
#echo nameserver 8.8.8.8 > /etc/resolv.conf

#apt update
#apt install -y initramfs-tools btrfs-progs

touch /etc/cloud/cloud-init.disabled

echo btrfs >> /etc/initramfs-tools/modules

echo "RESUME=none" > /etc/initramfs-tools/conf.d/resume
update-initramfs -c -k all

sed -i "s/PLACEHOLDER/$volname/" /boot/firmware/cmdline.txt 
sed -i "s/PLACEHOLDER/$volname/" /etc/fstab

useradd -G sudo -s /bin/bash -d /home/pi -m pi
echo "pi:raspberry" | chpasswd
echo "pi ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/010_pi-nopasswd
chmod 0440 /etc/sudoers.d/010_pi-nopasswd

echo "ubuntu:ubuntu" | chpasswd


