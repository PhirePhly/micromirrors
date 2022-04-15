# Micro Mirrors

An Ansible playbook to configure a Linux software mirror ready to be added to the public pools.

This project spawned as a thought experiment while working on the [FCIX mirror](https://mirror.fcix.net/) as to how software mirrors seem to always scale veritcally, and if it would be possible to build a meaningfully useful mirror for less than the $320 cost of one of the 16TB hard drives being used in the FCIX mirror.

Given this constraint of a hardware budget of $320, servers would be cheap and small enough that a larger number of them could be built and deployed to make a more distributed CDN that is less reliant on single hosts for capacity.
This objective also meshes well with the fact that the two of us working on this project happen to have a large number of personal contacts at "eyeball ISPs", which are the ISPs used by consumers to get Internet at home.
Eyeball ISPs handle primarily ingress traffic for their users consuming Internet content, so their equal egress capacity on the transit market chronically tends to be under-utilized.
A mirror server that was negligibly small and low power would mean the hosts could stick the servers in their transit DC locations to utilize their surplus egress capacity at effectively no expense.

Each server would only be capable of hosting a small number of the relatively smaller projects (i.e. 3-6 of the 100GB-400GB projects).
This would mesh well with micro mirrors only have a 1Gbps NIC, making it an easier proposition to deploy one of these nodes since 1G ports on routers tend to not be in short supply and the risk of a single server pumping out 1Gbps of traffic seems less daunting than a higher capacity network port.

## Hosting Sponsor Requirements

The sponsors of the Micro Mirrors would generally be any sort of network with a DC presence, surplus egress capacity, and a lack of manpower or inclination to host and manage their own open source software mirror.
Many ISPs (i.e. Ziply, Sonic, etc) already host their own (presumably more traditional) mirrors, and this project is not meant to discourage those efforts, but makes these networks not the target host because they're already willing to build their own mirror.

The qualified host lacks this interest and motivation, and the resources needed from them would be limited to the follow:
* sub-1RU of rack space for the hardware
* <30W delivered on a NEMA5 or C13 receptacle as 120V-240V
* 1Gbps baseT with both IPv4 and IPv6 static IP addresses and default routes

Additional nice to have features would be:
* PTR reverse records for the IP addresses.
* The ability to treat egress traffic from the Micro Mirrors as scavenger class traffic, either based on the port or on the DSCP CS1 marking from the server. Alternatively such a gross surplus of egress capacity that the worst case 1Gbps wouldn't be a concern.

The Micro Mirrors all carry SPONSOR.mm.fcix.net URLs, such that the host sponsor can get their name and visiblity on the project mirror lists, but it is still hopefully clear that any issues with the mirror should be raised with the FCIX NOC and not the hosting network's support team.

## Rev 1 Hardware Design

* HP T620 Thin Client - $20 eBay
* HP T620 power supply - $11 eBay
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

