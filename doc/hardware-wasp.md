# Rev 1 Hardware Design - Codename Wasp

Fanless mirror based on the HP T620 thin client with:
* 1GbaseT Ethernet
* 2TB SSD
* ~11W usage

10"x10" by 1.5" thick

## Estimated BOM cost on eBay

* HP T620 Thin Client + PSU - $35
* 2x4GB DDR3 PC3L SODIMM - $20
* 2TB M.2 SATA SSD - $160
* C14 / NEMA-5R adapter - $4

The [HP T620](https://www.parkytowers.me.uk/thin/hp/t620/) is a fanless thin client with the following specs:

* AMD GX-415GA quad core SOC, 1.5GHz
* Standard 19V HP power input barrel
* Two DDR3 SODIMM slots
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

