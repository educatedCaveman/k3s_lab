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
some `sysctl` values need setting. [this](https://phoenixnap.com/kb/sysctl) page is a good summary of the commands. However, the values wont stick after rebooting. A more proper way I think will be to use the `sysctl` ansible module. The playbook for k3s will have that.

### Config notes
1. setting fewer of the options seems to work best.
2. the winning combo seems to be:
    - set these:
        - `PUID`
        - `PGID`
        - `UMASK`
        - `TZ`
        - `FLOOD_AUTH`
        - `VPN_ENABLED`
        - `VPN_PROVIDER`
        - `VPN_CONF`
        - `VPN_LAN_NETWORK`
        - `VPN_PIA_USER`
        - `VPN_PIA_PASS`
    - but NOT these:
        - `VPN_EXPOSE_PORTS_ON_LAN`
        - `VPN_AUTO_PORT_FORWARD`
        - `VPN_AUTO_PORT_FORWARD_TO_PORTS`
        - `VPN_KEEP_LOCAL_DNS`
        - `VPN_FIREWALL_TYPE`
        - `VPN_HEALTHCHECK_ENABLED`
        - `VPN_PIA_DIP_TOKEN`
        - `VPN_PIA_PORT_FORWARD_PERSIST`
        - `PRIVOXY_ENABLED`
        - `UNBOUND_ENABLED`
    - optional:
        - `VPN_PIA_PREFERRED_REGION`

#### `VPN_PIA_PREFERRED_REGION`

The `VPN_PIA_PREFERRED_REGION` was hard to figure out correctly. I did figure it out though. I had to first, go [here](https://serverlist.piaservers.net/vpninfo/servers/v4). After formatting that JSON data, there was this in there:

```JSON
{
  "groups": {
    "snip": true
  },
  "regions": [
    {
      "id": "nl_amsterdam",
      "name": "Netherlands",
      "country": "NL",
      "auto_region": true,
      "dns": "nl-amsterdam.privacy.network",
      "port_forward": true,
      "geo": false,
      "servers": {
        "ikev2": [{ "ip": "<redacted>", "cn": "amsterdam403" }],
        "meta": [{ "ip": "<redacted>", "cn": "amsterdam403" }],
        "ovpntcp": [{ "ip": "<redacted>", "cn": "amsterdam403" }],
        "ovpnudp": [{ "ip": "<redacted>", "cn": "amsterdam403" }],
        "wg": [{ "ip": "<redacted>", "cn": "amsterdam403" }]
      }
    }
  ]
}
```

The key was to use the `id` value. The hotio tooltip mentions in certain circumstances

> you can't let it pick one randomly and are forced to fill in a **region id**

`id` = "region id"


## Secrets
In order to obfuscate the username and password required for PIA, I've had to create the secret manually, instead of via a manifest. I don't know if this is a skill issue, or if there is some technical limitation with linking the image with sealed secrets. 

Command used to create the secret:

```shell
k create secret generic pia-vpn-creds 
    --from-literal='username=__REDACTED__' \
    --from-literal='password=__REDACTED__' \
    -n prd
```

I also used a `secret.yml` file to populate the `wg0.conf` file.