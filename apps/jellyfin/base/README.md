this directory is where the core files go.  things like deployments, services, etc.



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




volume mounts:

config/cache/           2   GiB
config/data/data/       20  GiB
config/data/metadata/   5   GiB
config/log/             512 MiB