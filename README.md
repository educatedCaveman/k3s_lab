# k3s_lab

# install rancher:

install helm

```shell
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
```

add helm repo:

```shell
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
```

create rancher namespace:

```shell
kubectl create namespace cattle-system
```

    drake@theseus ~/github/k3s_lab > kubectl get namespaces
    NAME              STATUS   AGE
    cattle-system     Active   7s
    default           Active   115m
    kube-node-lease   Active   115m
    kube-public       Active   115m
    kube-system       Active   115m
    metallb-system    Active   115m


install `cert-manager`. The URL I'm using is different than the one in the guide.  this is likely just things changing the original author wasn't aware of

```shell
kubectl apply --validate=false -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.crds.yaml
```

```shell
kubectl create namespace cert-manager
```


 helm repo add jetstack https://charts.jetstack.io
 helm repo update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.14.4

drake@theseus ~/github/k3s_lab > kubectl get pods --namespace cert-manager
NAME                                      READY   STATUS    RESTARTS   AGE
cert-manager-6dc66985d4-zk4tr             1/1     Running   0          42s
cert-manager-cainjector-c7d4dbdd9-d7gcg   1/1     Running   0          42s
cert-manager-webhook-847d7676c9-qgxgr     1/1     Running   0          42s


```
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rancher.example.com
```

Error: INSTALLATION FAILED: chart requires kubeVersion: < 1.28.0-0 which is incompatible with Kubernetes v1.29.2+k3s1



this site has been useful!
https://medium.com/geekculture/bare-metal-kubernetes-with-metallb-haproxy-longhorn-and-prometheus-370ccfffeba9