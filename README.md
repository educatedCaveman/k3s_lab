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
| 192.168.13.20  | 192.168.13.239 | k3s services      | MetalLB virtual IPs                       |
| 192.168.13.240 | 192.168.13.249 | k3s services      | DHCP                                      |
| 192.168.13.250 | 192.168.13.251 | k3s services      | reserved, unused. for something important |
| 192.168.13.252 | n/a            | k3s data          | NFS server backed by proxmox disks        |
| 192.168.13.253 | n/a            | portainer         | haven't decided if this is permanent      |
| 192.168.13.254 | n/a            | k3s API IP        |                                           |
| 192.168.13.255 | n/a            | broadcast address |                                           |

### Service Useage

| Service | DEV IP:port          | PRD IP:port          | Notes |
| ------- | -------------------- | -------------------- | ----- |
| Homer   | `192.168.13.20:8080` | `192.168.13.21:8080` |       |

### Remaining IPs

`192.168.13.22` - `192.168.13.239`


# Useful Commands

To delete a deployment with as few commands as possible, use the following:

1. `kubectl describe service <POD_NAME> -n <NAMESPACE>` to query the service details.
2. `kubectl get all --selector app=<APP_SELECTOR>` to confirm all of these can be deleted
3. `kubectl delete all --selector app=<APP_SELECTOR> -n <NAMESPACE>` to delete the resources


## Specific Example

1. `kubectl describe service --namespace="dev-test" dev-nginx-testing`

    ```text
    Name:                     dev-nginx-testing
    Namespace:                dev-test
    Labels:                   <none>
    Annotations:              metallb.universe.tf/allow-shared-ip: nginx-testing-metallb-ip
                              metallb.universe.tf/ip-allocated-from-pool: first-pool
    Selector:                 app=nginx-testing
    Type:                     LoadBalancer
    IP Family Policy:         PreferDualStack
    IP Families:              IPv4
    IP:                       10.43.242.73
    IPs:                      10.43.242.73
    IP:                       192.168.13.101
    LoadBalancer Ingress:     192.168.13.101
    Port:                     <unset>  80/TCP
    TargetPort:               80/TCP
    NodePort:                 <unset>  31667/TCP
    Endpoints:                10.42.4.29:80
    Session Affinity:         None
    External Traffic Policy:  Cluster
    Events:
      Type     Reason            Age                    From                Message
      ----     ------            ----                   ----                -------
      Warning  AllocationFailed  2m25s (x2 over 6m54s)  metallb-controller  Failed to allocate IP for "dev-test/dev-nginx-testing": can't change sharing key for "dev-test/dev-nginx-testing", address also in use by dev-test/nginx-server
      Normal   IPAllocated       23s                    metallb-controller  Assigned IP ["192.168.13.101"]
      Normal   nodeAssigned      23s                    metallb-speaker     announcing from node "k3s-master-03" with protocol "layer2"
    ```

2. `kubectl get all --selector app=nginx-testing`

    ```text
    NAME                                     READY   STATUS    RESTARTS   AGE
    pod/dev-nginx-testing-7d7654b77f-zn5g9   1/1     Running   0          10m

    NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/dev-nginx-testing   1/1     1            1           10m

    NAME                                           DESIRED   CURRENT   READY   AGE
    replicaset.apps/dev-nginx-testing-7d7654b77f   1         1         1       10m
    ```

3. `kubectl delete all --selector app=nginx-testing -n dev-test`

    ```text
    pod "dev-nginx-testing-7d7654b77f-zn5g9" deleted
    deployment.apps "dev-nginx-testing" deleted
    replicaset.apps "dev-nginx-testing-7d7654b77f" deleted
    ```