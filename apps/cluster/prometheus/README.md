# Prometheus

TODO: get this working with manifests

steps to install prometheus:

add repo
```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

update the repo, just in case?
```shell
helm repo update
```

create namespace for prometheus
```shell
k apply -f namespaces.yml
```

login secrets
```shell
k create secret generic grafana-admin-credentials \
    --from-literal='admin-user=__REDACTED__' \
    --from-literal='admin-password=__REDACTED__' \
    -n monitoring
```

install prometheus
```shell
helm install -n monitoring prometheus prometheus-community/kube-prometheus-stack -f values.yaml
```

patch the service to use metalLB
```shell
k -n monitoring patch svc grafana -p '{"spec": {"type": "LoadBalancer", "loadBalancerIP": "192.168.13.237"}}'
```

## Updating

```shell
helm upgrade -n monitoring prometheus prometheus-community/kube-prometheus-stack -f values.yaml
k -n monitoring patch svc grafana -p '{"spec": {"type": "LoadBalancer", "loadBalancerIP": "192.168.13.237"}}'
```