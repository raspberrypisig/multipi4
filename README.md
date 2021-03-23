# MultiPi4

Create a USB/SSD MultiBoot Disk for Raspberry Pi 4.

My strong recommendation is boot from a SD card running Raspberry Pi OS 64-bit desktop from the Pi 4 itself, then install the software there.

# Installation


Run the following command as normal user(eg.pi), not root user:

```sh
curl -sSL https://bit.ly/37I1glx | bash -
```

# Prerequisites
- You need the OSes you want to install already downloaded and unzipped.

# Starting software

Menu->Accessories->MultiPi4


# OS Support

Currently, the following operating systems can be installed:

- All variants of Raspberry Pi OS(Lite, Desktop) and any distro based on it (eg. Retropie)
- Ubuntu (Server,Desktop)

# How It Works

* Creates three partitions on your USB/SSD drive
    1. FAT32 partition containing the boot files of Alpine OS (boot OS). 
       When you powerup your Pi with USB/SSD drive, this is the OS that boots, it presents the OS selection menu.
       
    2. FAT32 partition, initially empty. When you select an OS, it populates this partition
       with the necessary boot files in order to boot into the selected OS. 
       
    3. BTRFS partition, contains the linux partition of the boot OS and the installed OSes as
       BTRFS subvolumes
 
# Issues

Major problem with booting Raspbian. Currently, I am using the same startup.elf/fixup.dat files for the different OSes, and that is causing major headaches
because it can get old over time.

Figured out a hack, but it is ugly.

config.txt

```
# Enable DRM VC4 V3D driver on top of the dispmanx display stack
# I had issues with this.
# My hack: use different overlay, uncomment 

#dtoverlay=vc4-fkms-v3d-pi4


#then, comment these 2

dtoverlay=vc4-fkms-v3d
max_framebuffers=2

# if it boots, that is good, if it shows piwiz, better, but you will find that vcgencmd version hangs. Bad, then change it back to original.
# Hopefully, on the next boot, it is good again.
```


