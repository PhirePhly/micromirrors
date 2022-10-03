

bond setup
https://www.nodeum.io/howto/lacp-bonding-configuration-by-using-nmcli-centos-or-rhel-7

```
nmcli con add type bond con-name wan0 ifname wan0 mode 802.3ad
nmcli con mod id wan0 bond.options mode=802.3ad,miimon=100,lacp_rate=fast,xmit_hash_policy=layer3+4
nmcli con add type bond-slave ifname em3 con-name em3 master wan0
```
