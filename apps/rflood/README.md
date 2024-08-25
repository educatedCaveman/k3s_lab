# rFlood

## Wireguard
The docker image I'm using here optionally has VPN functionality built-in. However, it uses the Wireguard protocol, which my existing/preferred VPN does not support. The documentation for this image has a couple known-good/recommended providers. I've chosen to use *PrivateInternetAccess* (PIA), but apparently, they do not provide a mechanism for downloading a known-good wireguard config file, which this docker image requries. To address this, I found [this](https://github.com/hsand/pia-wg), which may be able to generate one for me. I've added it as a submodule; if it works, it will be very useful to just have it present here at all times.

### Install/Configuration

Download, add to repo:
```shell
cd apps/rflood
git submodule add https://github.com/hsand/pia-wg.git
```

Generate config file:
```shell
# sudo apt install git python3-venv wireguard openresolv
# git clone https://github.com/hsand/pia-wg.git
cd pia-wg
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Run the tool:
```shell
python3 generate-config.py
```

There should then be a config file to be used as necessary. Presently, I think the simplest option is to add the entire file to k3s as a secret.

### Sysctl
some `sysctl` values need setting. [this](https://phoenixnap.com/kb/sysctl) page is a good summary of the commands.


## Secrets
In order to obfuscate the username and password required for PIA, I've had to create the secret manually, instead of via a manifest. I don't know if this is a skill issue, or if there is some technical limitation with linking the image with sealed secrets. 

Command used to create the secret:

```shell
k create secret generic pia-vpn-creds 
    --from-literal='username=__REDACTED__' \
    --from-literal='password=__REDACTED__' \
    -n prd
```