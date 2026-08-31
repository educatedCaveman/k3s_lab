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

## Troubleshooting

After my NAS debacle, when I brought the cluster back up, I found the gpu-operator pods wouldn't start. I tried finding a repair solution, but I think uninstalling it, and reinstalling it worked, sorta:

```shell
helm list -A
```

should output something like:

    NAME                    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                           APP VERSION
    gpu-operator-1786727246 gpu-operator    1               2026-08-14 13:07:27.712903401 -0400 EDT deployed        gpu-operator-v26.3.3            v26.3.3    
    prometheus              monitoring      1               2026-08-14 13:49:23.26399779 -0400 EDT  deployed        kube-prometheus-stack-88.3.0    v0.93.0    

given the output above, run the following command:

```shell
helm uninstall gpu-operator-1786727246 -n
```

after running the above install command, things seemed to mostly work, but the validator pods weren't. however, workloads still seemed to get scheduled, so not sure what to do about that.