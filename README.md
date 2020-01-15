# Secure Download LXC for Proxmox
A collection of programs, services, and configurations that will enable easy setup of a download server that is secured with OpenVPN.
Intended to be used in Proxmox with an unprivileged LXC.  

Features the following:
- Deluge (deluged + deluge-web)
- Sonarr
- Radarr
- Jackett
- OpenVPN
- UFW

## Setup
1. Append the following to your .conf file, located in `/etc/pve/lxc`:
```
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
lxc.cgroup.devices.allow = c 10:200 rwm
```

2. Start the container and clone this repo

3. Execute `./install.sh`

4. _Coming soon: UFW configuration_
