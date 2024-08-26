this directory is where the core files go.  things like deployments, services, etc.

# Secrets
In order to obfuscate the username and password required for ExpressVPN, I've had to create the secret manually, instead of via a manifest. I don't know if this is a skill issue, or if there is some technical limitation with linking the `haugene/transmission-openvpn` image with sealed secrets. 

Command used to create the secret:

```shell
k create secret generic express-vpn-creds 
    --from-literal='username=__REDACTED__' \
    --from-literal='password=__REDACTED__' \
    -n prd
```