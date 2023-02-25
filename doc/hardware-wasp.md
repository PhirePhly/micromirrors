# Rev 1 Hardware Design - Codename Wasp

Fanless mirror based on the HP T620 thin client with:
* 1GbaseT Ethernet
* 2TB SSD
* ~11W usage

Approx 10"x10" by 1.6" thick (25.4cm x 25.4cm x 3.81cm)

## Estimated BOM cost on eBay

* HP T620 Thin Client + PSU - $35
* 2x4GB DDR3L PC12800 SODIMM - $20
* 2TB M.2 SATA SSD - $160
* C14 / NEMA-5R adapter - $4

The [HP T620](https://www.parkytowers.me.uk/thin/hp/t620/) is a fanless thin client with the following specs:

* AMD GX-415GA quad core SOC, 1.5GHz
* Standard 19V HP power input barrel
* Two DDR3L PC12800 SODIMM slots (Maximum of 16GB supported)
* One M.2 B key SATA slot supporting 2242, 2260, and 2280 SSDs.
* One 1GbaseT NIC
* Four external USB2 and two USB3 ports
* Two internal USB ports
* Approx 11W power consumption


## Provisioning Checklist

Ensure BIOS is configured to power on after power loss.

Configure on-board graphics to forced 32M

Assemble hardware and install Alma 8 with following settings:
* No root user
* User `mirror` as an administrator
* No LVM, Standard partition table with one large `/` XFS partition
* Minimal software configuration

Once booted into the new install:
* Edit `/etc/sysconfig/network-scripts/ifcfg-enp1s0` to have correct IP addresses
* `sudo visudo` to change wheel group to have NOPASSWD:ALL

Add the host to the Ansible inventory, and create a host_vars file for the system selecting the desired projects for this micro mirror.

Add IP addresses to mirror.fcix.net rsync ACLs

Run playbook and wait for system to pull in full project repo. Ensure that automatic update scripts are running correctly.

Contact projects requesting that the new mirror be added to their load balancers.


For Alma9, need to use udev to rename interfaces. `/etc/udev/rules.d/70-custom-ifnames.rules` Would be nice to find rule based on PCI address...

```
SUBSYSTEM=="net",ACTION=="add",ATTR{address}=="00:8c:fa:d3:6e:d7",ATTR{type}=="1",NAME="wan0"
```


Hard drive partitioning

```
ignoredisk --only-use=/dev/disk/by-path/pci-0000:00:11.0-ata-2
# Partition clearing information
clearpart --all --initlabel --drives=/dev/disk/by-path/pci-0000:00:11.0-ata-2
# Disk partitioning information
part swap --fstype="swap" --ondisk=/dev/disk/by-path/pci-0000:00:11.0-ata-2 --size=2048
part /boot --fstype="xfs" --ondisk=/dev/disk/by-path/pci-0000:00:11.0-ata-2 --size=1024
part / --fstype="xfs" --ondisk=/dev/disk/by-path/pci-0000:00:11.0-ata-2 --size=1904056
part /boot/efi --fstype="efi" --ondisk=/dev/disk/by-path/pci-0000:00:11.0-ata-2 --size=600 --fsoptions="umask=0077,shortname=winnt"
```

