# k3s_lab

Doing a reset, bc the cluster is fucked

## TODOS

DOCUMENT EVERYTHING, DUMBASS!!!!!

- [X] update VMs - other ansible stuff, too - fastfetch
- [X] base config
- [X] longhorn, including ingress
- [/] deploy applications
  - [/] applications
    - [ ] apt-cache
      - [ ] configure clients, too
    - [x] homer
    - [/] languagetool
    - [ ] nebula-sync
    - [ ] pi-hole
    - [x] syncthing
    - [ ] unifi
  - [/] media
    - [x] bazarr
    - [x] cleanuparr
    - [x] flaresolverr
    - [x] jellyfin
    - [x] lidarr
    - [/] navidrome
    - [x] prowlarr
    - [x] qBittorrent
    - [x] radarr
    - [x] sonarr
    - [/] whisparr
    - [ ] whisper

### GPU nodes

nVidia update:

```shell
sudo apt install --only-upgrade libnvidia-cfg1-550 libnvidia-compute-550 libnvidia-decode-550 libnvidia-encode-550 nvidia-compute-utils-550 nvidia-dkms-550 nvidia-headless-550 nvidia-headless-no-dkms-550 nvidia-kernel-common-550 nvidia-kernel-source-550 nvidia-utils-550
```

#### set interface name

open `/etc/netplan/50-cloud-init.yaml`, and update to include the `set-name` and `match` sections:

```yaml
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
  ethernets:
    enp6s18:
      dhcp4: true
      set-name: eth0
      match:
        macaddress: bc:24:11:2a:15:39
  version: 2
```

heed the warming, and create the file

```shell
sudoedit /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
```

and paste `network: {config: disabled}` into it

apply netplan:

```shell
sudo netplan apply
```

reboot to verify

### Longhorn

pull the config file, replacing the version number with the desired version:

```shell
curl -sSfL https://raw.githubusercontent.com/longhorn/longhorn/v1.11.3/deploy/longhorn.yaml -o longhorn-v1.11.3.yaml
```

apply with:

```shell
kubectl apply -f longhorn-v1.11.3.yaml
```

#### Ingress

https://medium.com/geekculture/bare-metal-kubernetes-with-metallb-haproxy-longhorn-and-prometheus-370ccfffeba9

edit the service. change the `type` property to `ClusterIP` to `NodePort`:

```shell
kubectl edit service longhorn-frontend -n longhorn-system
```

get the port it uses:

```shell
kubectl get service longhorn-frontend -n longhorn-system
```

output:

```
NAME                TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
longhorn-frontend   NodePort   10.43.75.69   <none>        80:31550/TCP   13m
```

#### UI config

- disable node scheduling for all nodes other than the data nodes
- backup configuration

### GPU

follow instructions in [this README](/apps/cluster/nvidia/README.md)

### Prometheus

follow instructions in [this README](/apps/cluster/prometheus/README.md)

### Sealed Secrets

follow instructions in [this README](/apps/cluster/sealed-secrets/README.md)

## Useful sites:

- https://medium.com/geekculture/bare-metal-kubernetes-with-metallb-haproxy-longhorn-and-prometheus-370ccfffeba9
- https://docs.openshift.com/container-platform/4.9/networking/metallb/metallb-configure-services.html

## Special steps

### NFS folder directly in container

in order to do this, you also need to share that folder in the TrueNAS GUI

## IP Address Use

### Ranges

| IP (start)     | IP (end)       | Purpose           | Note                                      |
| -------------- | -------------- | ----------------- | ----------------------------------------- |
| 192.168.13.0   | n/a            | network address   |                                           |
| 192.168.13.1   | n/a            | router            |                                           |
| 192.168.13.2   | 192.168.13.10  | k3s managers      | presently, only \*.2 - \*.4 are used      |
| 192.168.13.11  | 192.168.13.19  | k3s workers       | presently, only \*.11 - \*.14 are used    |
| 192.168.13.20  | 192.168.13.25  | k3s workers       |                                           |
| 192.168.13.26  | 192.168.13.239 | k3s services      | MetalLB virtual IPs                       |
| 192.168.13.240 | 192.168.13.249 | k3s services      | DHCP                                      |
| 192.168.13.250 | 192.168.13.251 | k3s services      | reserved, unused. for something important |
| 192.168.13.252 | n/a            | k3s data          | NFS server backed by proxmox disks        |
| 192.168.13.253 | n/a            | portainer         | haven't decided if this is permanent      |
| 192.168.13.254 | n/a            | k3s API IP        |                                           |
| 192.168.13.255 | n/a            | broadcast address |                                           |

### Nodes

| Name            | Hostname   | IP              | VM ID | CPU | MEM | MAC               | Notes                           |
| --------------- | ---------- | --------------- | ----- | --- | --- | ----------------- | ------------------------------- |
| k3s-manager-01  | apis-1     | `192.168.13.2`  | 302   | 4   | 4   | BC:24:11:EB:00:CE |                                 |
| k3s-manager-02  | apis-2     | `192.168.13.3`  | 303   | 4   | 4   | BC:24:11:3E:49:42 |                                 |
| k3s-manager-03  | apis-3     | `192.168.13.4`  | 304   | 4   | 4   | BC:24:11:FB:DE:2B |                                 |
| k3s-worker-01   | vespae-1   | `192.168.13.11` | 311   | 8   | 16  | BC:24:11:BD:19:E9 |                                 |
| k3s-worker-02   | vespae-2   | `192.168.13.12` | 312   | 8   | 16  | BC:24:11:0F:C4:04 |                                 |
| k3s-worker-03   | vespae-3   | `192.168.13.13` | 313   | 8   | 16  | BC:24:11:E5:E9:D1 |                                 |
| k3s-worker-04   | vespae-4   | `192.168.13.14` | 314   | 8   | 16  | BC:24:11:78:92:D2 |                                 |
| k3s-worker-05   | vespae-5   | `192.168.13.15` | 315   | 8   | 16  | BC:24:11:8F:21:CD |                                 |
| k3s-worker-06-g | vespae-6   | `192.168.13.16` | 316   | 8   | 8   | BC:24:11:3E:4F:B2 | g=GPU                           |
| k3s-worker-07-g | vespae-7   | `192.168.13.17` | 317   | 8   | 8   | BC:24:11:5A:C1:CD | g=GPU                           |
| k3s-worker-08-g | vespae-8   | `192.168.13.18` | 318   | 8   | 8   | BC:24:11:2A:15:39 | g=GPU                           |
| k3s-worker-09-g | vespae-9   | `192.168.13.19` | 319   | 8   | 8   | BC:24:11:DD:EC:E9 | g=GPU                           |
| k3s-data-01     | formicae-1 | `192.168.13.20` | 320   | 4   | 4   | BC:24:11:EE:E6:3A | 500GB NVMe device passed though |
| k3s-data-02     | formicae-2 | `192.168.13.21` | 321   | 4   | 4   | BC:24:11:D4:B3:71 | 500GB NVMe device passed though |
| k3s-data-03     | formicae-3 | `192.168.13.22` | 322   | 4   | 4   | BC:24:11:F4:85:A1 | 500GB NVMe device passed though |
| k3s-data-04     | formicae-4 | `192.168.13.23` | 323   | 4   | 4   | BC:24:11:12:A2:C0 | 500GB NVMe device passed though |
| k3s-data-05     | formicae-5 | `192.168.13.24` | 324   | 4   | 4   | BC:24:11:BB:DC:EC | 500GB NVMe device passed though |
| k3s-data-06     | formicae-6 | `192.168.13.25` | 325   | 4   | 4   | BC:24:11:9E:5B:9F | 500GB NVMe device passed though |

### Service Useage

| Service           | URL                             | IP:port                        | Notes                     |
| ----------------- | ------------------------------- | ------------------------------ | ------------------------- |
| Homer             | https://homer.drak3.io          | `192.168.13.27:8080`           |                           |
| Jellyfin          | https://jellyfin.drak3.io       | `192.168.13.28:8096`           |                           |
| Syncthing         | https://sync.drak3.io           | `192.168.13.29:8384`           |                           |
| Flaresolverr      | n/a                             | `192.168.13.30:8191`           |                           |
| Prowlarr          | https://prowlarr.drak3.io       | `192.168.13.31:9696`           |                           |
| Radarr            | https://radarr.drak3.io         | `192.168.13.32:7878`           |                           |
| Sonarr            | https://sonarr.drak3.io         | `192.168.13.33:8989`           |                           |
| Lidarr            | https://lidarr.drak3.io         | `192.168.13.34:8686`           |                           |
| Bazarr            | https://bazarr.drak3.io         | `192.168.13.35:6767`           |                           |
| qBittorrent       | https://qbt.drak3.io            | `192.168.13.38:8080`, `*:3000` | qBittorrent + VPN         |
| whisper           | n/a                             | `192.168.13.39:9000`           |                           |
| Home Assistant    | https://home-assistant.drak3.io | `192.168.13.40:8123`           | testing Home Assistant    |
| Navidrome         |                                 | `192.168.13.41`                |                           |
| Whisparr          |                                 | `192.168.13.42`                |                           |
| Cleanuparr        |                                 | `192.168.13.43`                |                           |
|                   |                                 | `192.168.13.44`                | free address for services |
|                   |                                 | `192.168.13.234`               | free address for services |
| LanguageTool      |                                 | `192.168.13.235`               |                           |
| Pi-Hole           | https://pihole3.drak3.io        | `192.168.13.236`               | W.I.P.                    |
| Grafana           | https://grafana.drak3.io        | `192.168.13.237:80`            |                           |
| Apt Cache         | https://apt.drak3.io            | `192.168.13.238:3142`          |                           |
| Unifi Network App | https://unifi.drak3.io          | `192.168.13.239:8443`          |                           |
|                   |                                 | `192.168.13.240`               |                           |
|                   |                                 | `192.168.13.241`               |                           |
|                   |                                 | `192.168.13.242`               |                           |
|                   |                                 | `192.168.13.243`               |                           |
|                   |                                 | `192.168.13.244`               |                           |
|                   |                                 | `192.168.13.245`               |                           |
|                   |                                 | `192.168.13.246`               |                           |
|                   |                                 | `192.168.13.247`               |                           |
|                   |                                 | `192.168.13.248`               |                           |
| Longhorn          | https://longhorn.drak3.io       | `192.168.13.249:31550`         |                           |

### Remaining IPs

- `192.168.13.39` - `192.168.13.234`
