the `controller.yml` manifest was obtained by running:

```shell
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.27.1/controller.yaml
```

A local CLI utility, `kubeseal`, is also required. It is available via the Manjaro package repository.


# Creating

Create a file `secret.yml` like the following:

```yml
---
apiVersion: v1
kind: Secret
metadata:
  name: super-duper-secret
  namespace: secretapp
type: Opaque
data:
  key1: "<base64 value>"
  key2: "<base64 value>"
```

obtain the base64 values:

```shell
echo mysupersecretthingy | base64
```

and populate them into the file.

When the file is ready, create the sealed secret:

```bash
kubeseal --format=yaml < secret.yml > sealed-secret.yml
```

Then apply it to the cluster:

```bash
k apply -f sealed-secret.yml
```

Optionally, verify it was applied:

```bash
k get secret -n secretapp super-duper-secret
```

# Using

## Update `deployment.yml`

The following is an abbreviated example of how to use the secret values:

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
spec:
  template:
    spec:
      restartPolicy: Always
      containers:
        - name: my-app-with-secret
          env:
          - name: SECRET_1
            valueFrom:
              secretKeyRef:
                name: super-duper-secret
                key:  key1
```

## Update `kustomization.yml`

Add the sealed secret to `kustomize.yml`

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: secretapp
resources:
  - sealed-secret.yml
```

## Apply

Apply the secret (and any other changes) with:

```bash
k apply -k .
```
