# Micro Mirrors

An Ansible playbook to configure a Linux software mirror ready to be added to the public pools.

This project spawned as a thought experiment while working on the [FCIX mirror](https://mirror.fcix.net/) as to how software mirrors seem to always scale veritcally, and if it would be possible to build a meaningfully useful mirror for less than the cost of one of the 16TB hard drives being used in the FCIX mirror.
Given a total hardware budget of $320, servers would be cheap enough to be accessible for more people, and allow a larger number of them to be deployed in a distributed manner, helping spread the load of the Distro CDN across more smaller hosts.

## Rev 1 Hardware Design

* HP T620 Thin Client - $20 eBay
* HP T620 power supply - $15 eBay
* 2x4GB DDR3 PC3L SODIMM - $20 eBay
* 2TB M.2 SATA SSD - $160 eBay

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

Assemble hardware and install Alma 8 with following settings:
* No root user
* User `mirror` as an administrator
* No LVM, Standard partition table with one large `/` XFS partition
* Minimal software configuration

Once booted into the new install:
* Edit `/etc/sysconfig/network-scripts/ifcfg-enp1s0` to have correct IP addresses
* `sudo visudo` to change wheel group to have NOPASSWD:ALL

Add the host to the Ansible inventory, and create a host_vars file for the system selecting the desired projects for this micro mirror.

Identify upstream rsync sources for each project, and contact them for ACL access if needed.

Run playbook and wait for system to pull in full project repo. Ensure that automatic update scripts are running correctly.

Contact projects requesting that the new mirror be added to their load balancers.

