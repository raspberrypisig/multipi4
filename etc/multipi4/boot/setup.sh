#!/usr/bin/env bash

apt update
apt install -y initramfs-tools btrfs-tools btrfs-progs
echo btrfs >> /etc/initramfs-tools/modules	
VERSION=$(find /lib/modules -name *v7l+ -exec basename {} \; )
mkinitramfs -o /initramfs-btrfs -v $VERSION
# Disable kernel updates
apt-mark hold libraspberrypi-bin libraspberrypi-dev libraspberrypi-doc libraspberrypi0
apt-mark hold raspberrypi-bootloader raspberrypi-kernel raspberrypi-kernel-headers
apt remove -y --purge openssh-server
raspi-config nonint do_configure_keyboard us

services_disable=("resize2fs_once" "networking" "dhcpcd" "rpi-eeprom-update" "avahi-daemon" "dphys-swapfile" "wpa_supplicant" "rc-local" )
services_enable=("oschooser")
services_mask=("raspi-config" "regenerate_ssh_host_keys")

for service in "${services_disable[@]}"
do
  systemctl disable $service
done

for service in "${services_enable[@]}"
do
  systemctl enable $service
done

for service in "${services_mask[@]}"
do
  systemctl mask $service
done



