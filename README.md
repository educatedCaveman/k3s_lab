# k3s_lab

This is an experiment to use K3s to replace my old docker swarm stack. Currently, I'm still feeling things out, but I'm getting closer to the point where I think I could migrate things in earnest.

I've added the [k3s-ansible](https://github.com/techno-tim/k3s-ansible) repo from Techno Tim as a submodule.  I've also reorganized the repo a bit.

## Things I want to be able to do

### Done

- setup the cluster
- setup MetalLB
- setup, then abandon longhorn
  - longhorn is either a waste of time, or **WAY** too over my head right now.
- determine how to use local files for config/data
- deploy a workload to the k3s cluster
  - using namespaces

### TODO

- determine how to precisely set permissions for the NFS share
  - presently i have the entire share in the `nobody:nogroup` user:group, with 777 permissions. not ideal.
- CI/CD
- deploy existing stacks
- automate shutdown/reboot for maintenance
  - something leveraging the `kubectl drain` command.

## Useful sites:

- https://medium.com/geekculture/bare-metal-kubernetes-with-metallb-haproxy-longhorn-and-prometheus-370ccfffeba9
- https://docs.openshift.com/container-platform/4.9/networking/metallb/metallb-configure-services.html

## IP Address Use

### Ranges

| IP (start)     | IP (end)       | Purpose           | Note                                      |
| -------------- | -------------- | ----------------- | ----------------------------------------- |
| 192.168.13.0   | n/a            | network address   |                                           |
| 192.168.13.1   | n/a            | router            |                                           |
| 192.168.13.2   | 192.168.13.10  | k3s managers      | presently, only \*.2 - \*.4 are used      |
| 192.168.13.11  | 192.168.13.19  | k3s workers       | presently, only \*.11 and \*.12 are used  |
| 192.168.13.20  | 192.168.13.239 | k3s services      | MetalLB virtual IPs                       |
| 192.168.13.240 | 192.168.13.249 | k3s services      | DHCP                                      |
| 192.168.13.250 | 192.168.13.251 | k3s services      | reserved, unused. for something important |
| 192.168.13.252 | n/a            | k3s data          | NFS server backed by proxmox disks        |
| 192.168.13.253 | n/a            | portainer         | haven't decided if this is permanent      |
| 192.168.13.254 | n/a            | k3s API IP        |                                           |
| 192.168.13.255 | n/a            | broadcast address |                                           |

### Service Useage

| Service           | PRD IP:port           | DEV IP:port           | Notes                                 |
| ----------------- | --------------------- | --------------------- | ------------------------------------- |
| Homer             | `192.168.13.21:8080`  | `192.168.13.20:8080`  | Deleted - OOPS!                       |
| Privateer         | n/a                   |                       | WIP                                   |
| Flaresolverr      | `192.168.13.24:8191`  | n/a                   | prod-only                             |
| Plex Meta Manager | n/a                   | n/a                   | prod-only, but no IP                  |

### Remaining IPs

`192.168.13.22` - `192.168.13.239`
