
```shell
curl -sSfL https://raw.githubusercontent.com/longhorn/longhorn/v1.11.3/deploy/longhorn.yaml -o longhorn-v1.11.3.yaml
```

```shell
k apply -f longhorn-v1.11.3.yaml
```



patch the service to use metalLB
```shell
k -n longhorn-system patch svc longhorn-frontend -p '{"spec": {"type": "LoadBalancer", "loadBalancerIP": "192.168.13.249"}}'
```