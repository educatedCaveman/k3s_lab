# Kubeseal

## Useful links
- https://medium.com/@seifeddinerajhi/securely-managing-kubernetes-passwords-with-sealed-secrets-2fb331aa83d8

## Installation

### Client:

```shell
sudo pamac install kubeseal
```

### Server

```shell
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.27.1/controller.yaml
kubectl apply -f controller.yaml
```

Note: as of this writing, `v0.27.1` is the latest version

## Usage

`secret.yml`:

```yml
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  # my-secret-user
  username: bXktc2VjcmV0LXVzZXIK
  # my-secret-pass
  password: bXktc2VjcmV0LXBhc3MK
```

### Sealing

```shell
kubeseal --cert=pub-key-cert.pem --format=yaml < secret.yml > sealed-secret.yml
```

While it seems to work just fine with files having `.yml` extensions, it does seem to require `--format=yaml`, instead of `--format=yml`, which it doesn't seem to understand.

### Deploying

```shell
kubectl apply -f sealed-secret.yml