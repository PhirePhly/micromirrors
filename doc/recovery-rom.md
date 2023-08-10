# Recovery ROM

For the sake of saving effort, each Micro Mirror appliance ships with a USB flash drive inside of it with a recovery ROM in the case that the operating system needs to be rekickstarted.

Originally this consisted of a OEMDRV partition with ks.cfg relying on remote hands to insert an Alma 9.0 ISO as well.
Ideally we'd like to move to a single flash drive solution around embedding the kickstart file inside an Alma install media.

## Raw notes


https://access.redhat.com/solutions/60959

This gets the EFI part totally wrong. Oscar Juarez Perez is the MVP in the comments noting that you need to edit the grub file inside the efiboot.img inside the ISO, so you need to go two disk images deep.

https://serverfault.com/questions/965898/kickstart-install-what-disk-name-should-i-tell-anaconda-to-use-installer-runn

`cdrom` doesn't work as a install source for USB flash drives, you need something like the following:

```
harddrive --partition=LABEL="AlmaLinux-9-2-x86_64-dvd" --dir=/Minimal/
```

Notepad dump

```
mkisofs -o ../generic.iso -b isolinux/isolinux.bin -J -R -l -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e images/efiboot.img -no-emul-boot -graft-points -joliet-long -V "AlmaLinux-9-2-x86_64-dvd" .
isohybrid --uefi ../generic.iso
implantisomd5 ../generic.iso

LABEL="AlmaLinux-9-2-x86_64-dvd"
```

## Kickstart details

```
ignoredisk --drives=/dev/disk/by-path/*usb*
```

```
# Network information
network  --hostname=HOSTNAME.mm.fcix.net
network  --bootproto=static --device=wan0 --ip=192.0.2.2 --netmask=255.255.255.0 --gateway=192.0.2.1 --ipv6=2001:db8::2/64 --ipv6gateway=2001:db8::1 --nameserver=8.8.8.8,2606:4700:4700::1001,1.1.1.1 --activate --bondopts=mode=802.3ad,lacp_rate=fast,miimon=100,xmit_hash_policy=layer3+4 --bondslaves=enp1s0,enp2s0

# Run the Setup Agent on first boot
firstboot --disabled

ignoredisk --only-use=/dev/disk/by-path/pci-0000:00:11.0-ata-2
# Partition clearing information
clearpart --all --initlabel --drives=/dev/disk/by-path/pci-0000:00:11.0-ata-2
# Disk partitioning information
part swap --fstype="swap" --ondisk=/dev/disk/by-path/pci-0000:00:11.0-ata-2 --size=2048
part /boot --fstype="xfs" --ondisk=/dev/disk/by-path/pci-0000:00:11.0-ata-2 --size=1024
part /boot/efi --fstype="efi" --ondisk=/dev/disk/by-path/pci-0000:00:11.0-ata-2 --size=600 --fsoptions="umask=0077,shortname=winnt"
part / --fstype="xfs" --ondisk=/dev/disk/by-path/pci-0000:00:11.0-ata-2 --grow
```

Grow allows us to use any size SSD in the specific PCI location.
Ideally should rewrite this to just select whatever disk isn't the USB drive so we can have a common kickstart between wasp and termite.
