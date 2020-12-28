# MultiPi4

Create a USB/SSD MultiBoot Disk for Raspberry Pi 4.

My strong recommendation is boot from a SD card running Raspberry Pi OS 64-bit desktop from the Pi 4 itself, then install the software there.

# Installation


```sh
curl -sSL https://bit.ly/37I1glx | bash -
```

# Prerequisites
- At a minimum, you need to download Raspberry Pi OS Lite (unzipped), and any other supported os image you want to install (also unzipped)

# Starting software

Menu->Accessories->MultiPi4


# OS Support

Currently, the following operating systems can be installed:

- All variants of Raspberry Pi OS(Lite, Desktop) and any distro based on it (eg. Retropie)
- Ubuntu (Server,Desktop)

# How It Works

* Creates three partitions on your USB/SSD drive
    1. FAT32 partition containing the boot files of Raspberry Pi OS Lite (boot OS) 
    2. FAT32 partition, initially empty. When you select an OS, it populates this partition
       with the necessary boot files in order to boot into the selected OS. 
    3. BTRFS partition, contains the linux partition of the boot OS and the installed OSes as
       BTRFS subvolumes

