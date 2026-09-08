# Homepage

these manifests were created by starting with the files [here](https://gethomepage.dev/installation/k8s/), then making modifications:
1. separating out each config file from the `configmap.yml`
2. adding a `kustomization.yml`
3. collecting secrets into a `secret.yml` and a `sealed-secret.yml`

