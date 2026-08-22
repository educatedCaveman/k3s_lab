# GPU-OPERATOR

these install inistructions are based on [this](https://github.com/NVIDIA/gpu-operator) github readme.


```shell
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
```

```shell
helm repo update
```

```shell
helm install --wait --generate-name -n gpu-operator --create-namespace nvidia/gpu-operator --set driver.enabled=false --set toolkit.enabled=false
```