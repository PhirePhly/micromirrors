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

