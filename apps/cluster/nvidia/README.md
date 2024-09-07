```shell
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
```

```shell
helm repo update
```

```shell
helm install --wait gpu-operator -n gpu-operator --create-namespace nvidia/gpu-operator --set driver.enabled=false --set toolkit.enabled=false
```
