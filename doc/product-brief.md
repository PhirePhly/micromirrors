# Micro Mirror CDN

Linux Distributions and other free software projects rely on a free volunteer-run network of HTTP/RSYNC servers to host and serve project files as a zero cost CDN.

The traditional server hosted by volunteer organizations for this CDN is a large $2k-$5k server with 50TB-100TB of storage.
The Micro Mirror project is an experimental approach to adding server capacity to the free software community by deploying a large number of smaller servers which only have 2TB-8TB of storage and only host a few projects each.

The value in the Micro Mirror project is that the CDN nodes are provided to host networks as a remotely managed appliance, so the FCIX MM team manages the full fleet of servers remotely, and host networks only need to provide space, power, and network connectivity without needing to dedicate engineering time towards server management.

## Micro Mirror Thesis

This project stemmed from the realization that while a traditional free software mirror hosts ~50TB of project files, the majority of the bytes served by the mirror come from only 3-4TB of project files.
This means that while traditional mirrors are important, and critical for less popular projects, it is possible to remove a significant fration of the total load from these mirrors by deploying smaller mirrors hosting only the most popular project.

By hosting particularly hot content such as Ubuntu ISOs and the EPEL repository on these smaller mirrors, traditional mirror capacity is freed up to better serve the long tail of less popular projects and software.
This means that the Micro Mirror project not only benefits the directly hosted projects, but improves the user experience for other projects since the mirrors able to host their content are less burdened by the popular projects.

## Typical Mirror Workflow

When an organization is interested in hosting their own mirror for free software, the workflow usually resembles the following:

1. Purchase server and storage hardware.
2. Develop a software framework to download project files from  upsteam servers and keep the project files up to date. (The exact details vary per project)
3. Contact each project individually to have the new mirror registered in the project's load balancer (Completely different per project)
4. Continue to monitor the health of the mirror and update process once the mirror is in production.

This was the workflow originally followed by the FCIX team for our first mirror, but much of the software development done for this first mirror could be leveraged for additional mirrors with very little additional effort.
The Micro Mirror workflow leverages this one-time development cost:

1. Solicit [community cash donations](https://liberapay.com/phirephly/) to fund defined BOM cost for cheap ($300) server configurations.
2. Purchase server hardware and identify hosting sponsor willing to provide DC space, power, and network connection for the new node.
3. Kickstart Micro Mirror server with base operating system and network addresses provided by hosting sponsor. Ship bootstrapped server to host to deploy.
4. Once node is online, select hosted projects in orchestration configuration file for the node and wait several hours for initial download to complete.
5. Register the new node with relevant projects. This is done in bulk with sometimes several mirrors included in individual applications.
6. Add new node to the existing health monitoring system such that the FCIX team can be aware of any hardware or network issues quickly.

From the hosting sponsor's perspective, the Micro Mirror is a turnkey appliance, where they only need to provide network connecitivty and remote hands to install the hardware, where all sysadmin and monitor work is handled by the FCIX team with the economy of scale on our side.

## Hosting Sponsor Responsibilities and Benefits

Hosting sponsors are networks with surplus network capacity, who are interested in contributing to the free software communities without the ability or interest in dedicating engineering resources to the deployment and management efforts required to keep a mirror operation.

The hosting sponsor only needs to provide the following:
* Space and power for a minimal server provided by the FCIX Micro Mirror team (i.e. 1RU, <100W)
* Network connectivity and minimal IP addresses for the one server (i.e. /31 of IPv4 space, 1Gbps or 10Gbps port with an expected 1-4TB/day of usage)
* Remote hands to initially rack the server, and network engineering to assist with the initial turnup.
* Low priority remote hands to assist with basic hardware replacement or troubleshooting should there be a hardware failure in the field.

Once deployed, there is no urgency in response time to failures, or any hard requirements on availability.
When a free software mirror goes offline, the individual project's use health monitoring systems to dynamically remove mirrors from their load balancers, so a failure or maintenance window causes the mirror to be removed from the project until it is repaired and returned to service.

Hosting sponsors do experience some minor direct benefits from hosting a Micro Mirror node:

* Hosting sponsors are promoted in the hostname of the mirror, and linked to from the HTTP index header on the mirror.
* Any local servers or users which use a hosted project are deliberately routed to the local mirror, giving them low latency access to the hosted projects and avoiding use of ingress bandwidth from offsite mirrors.

