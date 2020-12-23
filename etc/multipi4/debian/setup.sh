#!/usr/bin/env bash
set -x

volname="$1"

sed -i "s/PLACEHOLDER/$volname/" /boot/firmware/cmdline.txt 
sed -i "s/PLACEHOLDER/$volname/" /etc/fstab

VERSION=$(find /lib/modules -name *-arm64 -exec basename {} \; )

echo "RESUME=none" > /etc/initramfs-tools/conf.d/resume

apt-mark hold linux-image-$VERSION
apt update
apt install -y network-manager apparmor

cat<<EOF > /etc/NetworkManager/NetworkManager.conf
[main]
dns=default
plugins=ifupdown,keyfile
autoconnect-retries-default=0
rc-manager=file
dhcp=internal
[ifupdown]
managed=true
[device]
wifi.scan-rand-mac-address=no
[keyfile]
unmanaged-devices=type:bridge;type:tun;type:veth
[logging]
backend=journal
EOF

systemctl disable dhcpcd
systemctl disable ModemManager






