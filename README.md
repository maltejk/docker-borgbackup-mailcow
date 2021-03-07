# borgbackup-mailcow

borgbackup-mailcow leverages borgmatic and borgbackup to create incremental backups
of a mailcow email server.

To do so, a `docker-compose.override.yml` and `mailcow-backup.conf` is needed, see
`examples/`. Also, be sure to mount a private SSH-key at `/root/.ssh/` inside the
container.

The image is based on `maltejk/borgbackup` for simplicity.
