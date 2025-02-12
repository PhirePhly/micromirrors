# Honeybee Hardware Design

This is a second generation MicroMirror design to replace the T620 and T620plus based wasp design with one based on the HP T740 thin client.
This is a significant step up in CPU power, PCIe bandwidth, and adds support for NVMe SSDs, making larger SSDs than 2TB possible.

This platform does have some downsides in that the T740 is more expensive than the T620 on eBay, has higher power compution, and now includes a fan by default.
This makes the T740 not an ideal replacement for 1G nodes, but we expect 10G to be the default POP handoff from now on, so it is likely that the existing inventory of Wasps will cover any 1G growth in the install base.

[Parky Towers link](https://www.parkytowers.me.uk/thin/hp/t740/)

CPU: [AMD Ryzen V1756B](https://www.cpubenchmark.net/cpu.php?cpu=AMD+Ryzen+Embedded+V1756B&id=3574)

## Bill of Materials

* HP T740 plus power supply (eBay, ~$100)
* 2x4GB DDR4 SODIMM ([Amazon](https://amzn.to/3WPiy9x), )
* ConnectX-3 2x10G NIC `MCX312A-XCBT` (eBay, ~$25)
** PSID MT_1080120023 firmware 2.42.5000
* USB Flash Drive, 16GB, low profile ([Amazon](https://amzn.to/4hJZy4R), ~$10)
* 4TB NVMe SSD ([Amazon](https://amzn.to/4hui9BE), ~$250)

## PCIe Topoloogy

NIC locations for wan0 port channel

* 1GbaseT on-board: enp2s0f0
* 2x10G CX312 ports: enp1s0, enp1s0d1

NVMe path for kickstart file:

```
ignoredisk --only-use=nvme0n1
# Partition clearing information
clearpart --none --initlabel
# Disk partitioning information
part swap --fstype="swap" --ondisk=nvme0n1 --size=7043
part /boot --fstype="xfs" --ondisk=nvme0n1 --size=1024
part /boot/efi --fstype="efi" --noformat --fsoptions="umask=0077,shortname=winnt"
part / --fstype="xfs" --ondisk=nvme0n1 --grow
```

## Benchmarking notes

Idle: 21W

20Gbps of HTTP traffic: 42W, 19% CPU utilization

20Gbps of HTTPS traffic: 65W, 35% CPU utilization

Note that it is extremely rare for any MicroMirror hosts to even touch 10Gbps for a few seconds, so these power consupmtion numbers should never be seen in the wild.
These measurements were done with the default 2x10G NIC and was saturating the NIC, where the PCIe slot has 60Gbps available, so ideally we should do a second round of benchmarking with a faster NIC to see if we can find the next bottleneck after Ethernet.

