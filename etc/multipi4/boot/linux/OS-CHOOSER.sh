#!/usr/bin/env bash

set -x

TEMP_DIR=/tmp/usb2
USB_DISK=$(findmnt -no SOURCE /boot | sed 's/1//')
BTRFS_DIR=/tmp/usb3

createsubvolumename() {
  name="$1"
  typeset -l newvolname
  newvolname=${name// /_}
  newvolname=${newvolname//./__}
  echo $newvolname  
}

mkdir -p $TEMP_DIR
mount ${USB_DISK}2 $TEMP_DIR
options=()

if [ -f $TEMP_DIR/oslist.txt ];
then
  while read line
  do
    options+=("$line" "$line")
  done < $TEMP_DIR/oslist.txt
else
  echo "No OSes installed."
  exit 1
fi

CHOICE=$(whiptail --title "Choose OS" --menu " "  --nocancel --noitem   20 70 5 "${options[@]}" 3>&1 1>&2 2>&3)
volname=$(createsubvolumename "$CHOICE")
echo $volname

find $TEMP_DIR -mindepth 1 -type d -exec rm -rf '{}' \;

mkdir $TEMP_DIR/$volname
mkdir -p $BTRFS_DIR
mount -o ro ${USB_DISK}3 $BTRFS_DIR

if [ -d $BTRFS_DIR/@${volname}/boot/firmware ];
then
cp "$BTRFS_DIR/@${volname}/boot/firmware/config.txt" $TEMP_DIR 
else
cp "$BTRFS_DIR/@${volname}/boot/config.txt" $TEMP_DIR 
fi

echo -e "\nos_prefix=${volname}/" >> $TEMP_DIR/config.txt
echo -e "\ndtparam=sd_poll_once=on\n" >> $TEMP_DIR/config.txt

if [ -d $TEMP_DIR/$volname ];
then
  rm -rf $TEMP_DIR/$volname
fi

mkdir -p $TEMP_DIR/$volname

if [ -d $BTRFS_DIR/@${volname}/boot/firmware ];
then
cp -r $BTRFS_DIR/@${volname}/boot/firmware/* $TEMP_DIR/$volname
else
cp -r $BTRFS_DIR/@${volname}/boot/* $TEMP_DIR/$volname
fi


umount $BTRFS_DIR
umount $TEMP_DIR
sync
rm -rf $BTRFS_DIR
rm -rf $TEMP_DIR
reboot 2
