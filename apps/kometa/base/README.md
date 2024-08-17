this directory is where the core files go.  things like deployments, services, etc.

# Create Secrets

the values are readily available

```shell
k create secret generic kometa-keys \
    --from-literal='plex_token=__REDACTED__' \
    --from-literal='tmdb_key=__REDACTED__' \
    --from-literal='radarr_token=__REDACTED__' \
    --from-literal='sonarr_token=__REDACTED__' \
    -n prd
```