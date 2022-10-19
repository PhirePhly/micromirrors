# Micro Mirrors

Small CDN servers to host the most popular free software content to maximize positive impact on the community.
Tiny 1RU or sub-1RU web servers provided to networks as a free managed appliance to use their surplus network capacity to help improve the user experience on Linux distributions.

This project spawned as a thought experiment while working on the [FCIX mirror](https://mirror.fcix.net/) as to how software mirrors seem to always scale veritcally, and if it would be possible to build a meaningfully useful mirror for less than the $320 cost of one of the 16TB hard drives being used in the FCIX mirror.

Given this constraint of a hardware budget of $320, servers would be cheap and small enough that a larger number of them could be built and deployed to make a more distributed CDN that is less reliant on single hosts for capacity.
This objective also meshes well with the fact that the two of us working on this project happen to have a large number of personal contacts at "eyeball ISPs", which are the ISPs used by consumers to get Internet at home.
Eyeball ISPs handle primarily ingress traffic for their users consuming Internet content, so their equal egress capacity on the transit market chronically tends to be under-utilized.
A mirror server that was negligibly small and low power would mean the hosts could stick the servers in their transit DC locations to utilize their surplus egress capacity at effectively no expense.

Each server would only be capable of hosting a small number of the relatively smaller projects (i.e. 3-6 of the 100GB-400GB projects).
This would mesh well with micro mirrors only have a 1Gbps NIC, making it an easier proposition to deploy one of these nodes since 1G ports on routers tend to not be in short supply and the risk of a single server pumping out 1Gbps of traffic seems less daunting than a higher capacity network port.

## Initial Experiment

Given this thesis that micro mirrors may be helpful to distros, we're building an initial fleet of them based on HP T620 thin clients with 8GB RAM / 2TB M.2 SATA SSDs in them.
The design is detailed in the `hardware/` folder, but the BOM cost for parts off ebay works out to roughly $220 each.

With these nodes, we're deploying them in a select number of sites with the objective of a single node per hosting AS and a single node per physical building, to try and distribute the fault domain of these mirrors.

To avoid increasing the rsync load on upstream mirrors, all of these micromirrors are pulling updates from the mirror.fcix.net "heavy iron" mirror.
This is handled with MQTT push messages for when repos have been updated (an idea taken from the Alpine linux distro) and each rsync transfer paced at 200Mbps to try and limit the ingress load on hosting networks, and to try and encourage multiple micromirrors to operate in lockstep as they get mirror.fcix.net to read files from disk and serve to all the requesting micromirrors.

Given the limited processing power of these micromirrors, telemetry will be pushed to a separate watchtower server to collect, store, and analyze the aggregate statistics of the constellation of Micro Mirrors.

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

## Project Registrations

Each project has a unique workflow for registering new mirrors.

* [Almalinux](https://wiki.almalinux.org/Mirrors.html)
* [ArchLinux](https://wiki.archlinux.org/title/DeveloperWiki:NewMirrors)
* [CentOS](https://wiki.centos.org/HowTos/CreatePublicMirrors)
* [CentOS-altarch](https://wiki.centos.org/HowTos/CreatePublicMirrors)
* [CentOS-Stream](https://wiki.centos.org/HowTos/CreatePublicMirrors)
* [EPEL](https://fedoraproject.org/wiki/Infrastructure/Mirroring)
* [GIMP](https://www.gimp.org/news/2021/10/06/official-mirror-policy/)
* [Linux Mint](https://linuxmint.com/mirrors.php)
* [Manjaro](https://wiki.manjaro.org/index.php/Manjaro_Mirrors) (email info@manjaro.org)
* [OpenSUSE](https://en.opensuse.org/openSUSE:Mirror_infrastructure)
* [Rocky](https://docs.rockylinux.org/guides/mirror_management/add_mirror_manager/)
* [RPMFusion](https://rpmfusion.org/Mirrors)
* [Ubuntu-releases](https://wiki.ubuntu.com/Mirrors)
* [Videolan](https://www.videolan.org/videolan/mirrors.html)

