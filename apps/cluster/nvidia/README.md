```shell
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
```

```shell
helm repo update
```

```shell
helm install --wait gpu-operator -n gpu-operator --create-namespace nvidia/gpu-operator --set driver.enabled=false --set toolkit.enabled=false
```

---

follow option 2 [here](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/upgrade.html) to update. this is where the `values-v25.3.0.yaml` file came from.