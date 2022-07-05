#!/usr/bin/env bash
set -x

volname="$1"

#mv /etc/resolv.conf /etc/resolv.conf.old
#echo nameserver 8.8.8.8 > /etc/resolv.conf

#apt update
#apt install -y initramfs-tools btrfs-progs

touch /etc/cloud/cloud-init.disabled

echo btrfs >> /etc/initramfs-tools/modules

VERSION=$(find /lib/modules -name '*-raspi' -exec basename {} \; )
echo "RESUME=none" > /etc/initramfs-tools/conf.d/resume
update-initramfs -c -k $VERSION
cp /boot/initrd.img-$VERSION /boot/firmware/initrd.img

sed -i "s/PLACEHOLDER/$volname/" /boot/firmware/cmdline.txt 
sed -i "s/PLACEHOLDER/$volname/" /etc/fstab

#mv /etc/resolv.conf.old /etc/resolv.conf

#systemctl disable sssd

apt-mark hold linux-headers-$VERSION linux-modules-$VERSION linux-image-$VERSION

#echo -e "ubuntu\nubuntu\n" | passwd ubuntu
#apt install -y network-manager
useradd -G sudo -s /bin/bash -d /home/pi -m pi
chown pi:pi /home/pi
echo -e "raspberry\nraspberry\n" | passwd pi
useradd -G sudo -s /bin/bash -d /home/pi -m ubuntu
chown ubuntu:ubuntu /home/ubuntu
echo -e "ubuntu\nubuntu\n" | passwd ubuntu
#chpasswd <<< "ubuntu:ubuntu"

