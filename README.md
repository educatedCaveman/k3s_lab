# k3s_lab

This is an experiment to use K3s to replace my old docker swarm stack. Currently, I'm still feeling things out, but I'm getting closer to the point where I think I could migrate things in earnest.

I've added the [k3s-ansible](https://github.com/techno-tim/k3s-ansible) repo from Techno Tim as a submodule. I've also reorganized the repo a bit.

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
| 192.168.13.20  | 192.168.13.25  | k3s workers       |                                           |
| 192.168.13.26  | 192.168.13.239 | k3s services      | MetalLB virtual IPs                       |
| 192.168.13.240 | 192.168.13.249 | k3s services      | DHCP                                      |
| 192.168.13.250 | 192.168.13.251 | k3s services      | reserved, unused. for something important |
| 192.168.13.252 | n/a            | k3s data          | NFS server backed by proxmox disks        |
| 192.168.13.253 | n/a            | portainer         | haven't decided if this is permanent      |
| 192.168.13.254 | n/a            | k3s API IP        |                                           |
| 192.168.13.255 | n/a            | broadcast address |                                           |

### Nodes

| Name           | Hostname   | IP              | VM ID | CPU | MEM | MAC               | Notes                           |
| -------------- | ---------- | --------------- | ----- | --- | --- | ----------------- | ------------------------------- |
| k3s-manager-01 | apis-1     | `192.168.13.2`  | 302   | 4   | 4   | BC:24:11:EB:00:CE | n/a                             |
| k3s-manager-02 | apis-2     | `192.168.13.3`  | 303   | 4   | 4   | BC:24:11:3E:49:42 | n/a                             |
| k3s-manager-03 | apis-3     | `192.168.13.4`  | 304   | 4   | 4   | BC:24:11:FB:DE:2B | n/a                             |
| k3s-worker-01  | vespae-1   | `192.168.13.11` | 311   | 8   | 8   | BC:24:11:BD:19:E9 | n/a                             |
| k3s-worker-02  | vespae-2   | `192.168.13.12` | 312   | 8   | 8   | BC:24:11:0F:C4:04 | n/a                             |
| k3s-data-01    | formicae-1 | `192.168.13.20` | 320   | 4   | 4   | BC:24:11:EE:E6:3A | 500GB NVMe device passed though |
| k3s-data-02    | formicae-2 | `192.168.13.21` | 321   | 4   | 4   | BC:24:11:D4:B3:71 | 500GB NVMe device passed though |
| k3s-data-03    | formicae-3 | `192.168.13.22` | 322   | 4   | 4   | BC:24:11:F4:85:A1 | 500GB NVMe device passed though |
| k3s-data-04    | formicae-4 | `192.168.13.23` | 323   | 4   | 4   | BC:24:11:12:A2:C0 | 500GB NVMe device passed though |
| k3s-data-05    | formicae-5 | `192.168.13.24` | 324   | 4   | 4   | BC:24:11:BB:DC:EC | 500GB NVMe device passed though |
| k3s-data-06    | formicae-6 | `192.168.13.25` | 325   | 4   | 4   | BC:24:11:9E:5B:9F | 500GB NVMe device passed though |

### Service Useage

| Service           | DEV IP:port          | PRD IP:port           | Notes                 |
| ----------------- | -------------------- | --------------------- | --------------------- |
| Homer             | `192.168.13.26:8080` | `192.168.13.27:8080`  | PRD doesn't exist yet |
| Jellyfin          | n/a                  | `192.168.13.28:8096`  | PRD-only              |
| Syncthing         | n/a                  | `192.168.13.29:8384`  |                       |
| Flaresolverr      | n/a                  | `192.168.13.30:8191`  |                       |
| Prowlarr          | n/a                  | `192.168.13.31:9696`  |                       |
| Radarr            | n/a                  | `192.168.13.32:7878`  |                       |
| Sonarr            | n/a                  | `192.168.13.33:8989`  |                       |
| Lidarr            | n/a                  | `192.168.13.34:8686`  |                       |
| Bazarr            | n/a                  | `192.168.13.35:6767`  |                       |
| Transmission-VPN  | n/a                  | `192.168.13.36:9091`  | WIP                   |
| NGINX             | `192.168.13.101:80`  | n/a                   | for testing           |
| Unifi Network App | n/a                  | `192.168.13.239:8443` |                       |

### Remaining IPs

`192.168.13.29` - `192.168.13.238`
