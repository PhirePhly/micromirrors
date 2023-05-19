# Bootstrapping Wasp Micro Mirror

These are instructions to bootstrap a new HP T620 "Wasp" model Micro Mirror into the constellation.

To begin with, ensure that you have an HP T620 with the following BIOS options set:
* Security - system security - Virtualization: Enable
* Power options - power loss: on
* On-board devices - video: forced. Video buffer: 32M

The Wasp2T configuration is 2x4GB SODIMM of RAM and a 2TB M.2 B key WDS200T2B0B SSD

You will need two additional USB flash drives and an Internet connection to download the OS during the install.

## Conceptual Overview

These instructions get the Wasp to a point where it is possible for the FCIX MM team to remotely log into the Alma OS installed and start running the various Ansible playbooks against it to fully configure it as a Micro Mirror.

The installation of the initial Alma8 Linux is performed using the "boot" Alma ISO and a second flash drive with the kickstart file containing answers to all of the installation questions so the process is hands off.

The Alma install media is prepared just like any regular manual Linux install, but the Alma Linux installer is smart enough to look for an extra magic file system labeled "OEMDRV", which tells the installer to look for a kickstart file on that file system named `ks.cfg`.
This kickstart file has all of the answers to prompts like how to lay out disk partitioning, what users to create, and what set of packages to install.

Once the initial installation is complete, it's possible that no further configuration is required.
Your situation may require modification of the `/etc/sysconfig/network-scripts/ifcfg-enp1s0` file if it wasn't possible to preload the network configuration in the kickstart file.
Kenneth/John will advise what the best option is here depending on your situation and what is configured in the provided kickstart file.

## Preparing the Alma Install Media

For the installer USB, you will need a >1GB USB flash drive which you're able to completely wipe out the file system and data on.

First download the [Alma boot ISO](http://mirror.fcix.net/almalinux/8.6/isos/x86_64/AlmaLinux-8.6-x86_64-boot.iso).

Once downloaded, we need to write the raw ISO onto the flash drive. In Linux, this is typically done by running something similar to `dd if=./AlmaLinux-8.....iso of=/dev/sdc` after identifying the flash drive's sdX letter using `lsblk`.

On Windows, some of the best tools for writing the ISO to a USB drive include [Rufus](https://rufus.ie/en/), [balenaEtcher](https://www.balena.io/etcher/), or [Win32DiskImager](https://win32diskimager.org/); depending on personal preference.

## Preparing the Kickstart Install Media

Taking a second flash drive, ensure that it has a regular FAT32 file system on it, but the file system needs to have the volume label of `OEMDRV`.
An easy way to set the FAT32 volume label on a file system in Windows is to right click on the disk and open the "Format..." dialog.
Most of the defaults are usually fine here, but the Volume Label field should be changed to "OEMDRV" so the Alma installer can recognize that we're trying to use the kickstart process here.

Once the file system is properly labeled, take the provided `ks.cfg` file from the FCIX MM team and place it in the root of this flash drive.
Safely eject this flash drive.

## Installation Process

When ready, attach an Ethernet cable, DisplayPort monitor, keyboard, and both prepared flash drives to the blank Wasp server.

Power on the Micro Mirror and immediately start pressing F9.
This should open the BIOS boot menu, which should include an option in the upper "UEFI" section referring to your flash drive that you wrote the Alma ISO to.
The exact name of the entry will depend on the brand of flash drive used.

Select this flash drive as the boot source, and it should prompt you to select one of three choics, including "Install Alma Linux" and "Check Medis and install Alma Linux".
The "check media and install" option is the default, and is correct.

Once you press enter on "check media and install" the process should proceed completely hands free.
It should take 1-2 minutes to check the media, which will print a percentage to the screen as it progresses.
After the media check, the textual installer menu should print and then scroll by without prompting for anything.
If the installer reports any errors involving the kickstart file being insufficient, reach out for assistance.

The Alma installer will then format the drive, download the latest versions of all of the packages needed to build the OS image, and install them.
This process should take 10-15 minutes on a reasonably fast Internet connection.

Once the install is complete, it should report that installation was successful and to press enter to reboot the system.
The system should prefer booting off the internal  SSD over the USB drives, but they are regardless no longer needed.

Ensure that removing power and re-apply power causes the system to power on and successfully boot into Alma Linux.
It should ultimately end on a login prompt after the system's hostname.

## Troubleshooting

When powering on the HP T620 server, if it progresses to the PXE boot screen where it has a spinning cursor while attempting to aquire a DHCP lease, it failed to detect any other boot media or you didn't press F9 fast enough after turning it on to break into the boot menu.

