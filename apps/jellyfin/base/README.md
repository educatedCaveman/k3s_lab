# Jellyfin

This app appears to be one of those which are definitely _NOT_ meant to be configured solely by config files. After tinkering, it seems like trying to insert all the configs is a lost cause, at least for now. Also, given the config-driven approach seems unfeasable, and the application is also media-driven, I'm going to have this as a prd-only app.

## Jellyfin Directory Structure

```
config/
├── cache
│   ├── temp
│   └── transcodes
├── data
│   ├── data
│   │   ├── device.txt
│   │   ├── jellyfin.db
│   │   ├── jellyfin.db-shm
│   │   ├── jellyfin.db-wal
│   │   ├── library.db
│   │   ├── library.db-shm
│   │   ├── library.db-wal
│   │   ├── playlists
│   │   └── ScheduledTasks
│   │       ├── 3a025083-141d-3c17-dd96-d5f9b951287b.js
│   │       └── f9b057c0-54e9-e6da-ee4a-88ffd146a403.js
│   ├── metadata
│   │   └── views
│   │       └── livetv
│   ├── plugins
│   │   └── configurations
│   │       ├── Jellyfin.Plugin.MusicBrainz.xml
│   │       └── Jellyfin.Plugin.Tmdb.xml
│   ├── root
│   │   └── default
│   │       └── Movies
│   │           ├── movies.collection
│   │           ├── Movies.mblink
│   │           └── options.xml
│   └── transcodes
├── encoding.xml
├── log
│   └── log_20240807.log
├── logging.default.json
├── lost+found
├── migrations.xml
├── network.xml
└── system.xml
```

### PVCs

before giving up, I tried setting up several volumes with the sizes shown below.

| Munt Path               |    Size |
| ----------------------- | ------: |
| `config/cache/`         |   2 GiB |
| `config/data/data/`     |  20 GiB |
| `config/data/metadata/` |   5 GiB |
| `config/log/`           | 512 MiB |
