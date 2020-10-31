location:
    # List of source directories to backup (required). Globs and
    # tildes are expanded.
    source_directories:
        - /backup
    repositories:
        - "$BORG_REPO"
    one_file_system: false

storage:
    archive_name_format: "mailcow-{now:%Y-%m-%dT%H:%M:%S}"
    encryption_passphrase: "$BORG_PASSPHRASE"
    compression: auto,zstd

retention:
    keep_daily: 7
    keep_weekly: 4
    keep_monthly: 6
    prefix: mailcow-

output:
    color: false

hooks:
    # List of one or more shell commands or scripts to execute
    # before creating a backup, run once per configuration file.
    before_backup:
        - echo "`date` - before_backup started"
        - set -x
        - docker exec $(docker ps -qf name=redis-mailcow) redis-cli save
        - |
          docker exec $(docker ps -qf name=mysql-mailcow) \
            /bin/sh -c "rm -rf /backup/mariadb/*; \
            mariabackup --user root --password ${DBROOT} --backup --rsync --target-dir=/backup/mariadb ; \
            mariabackup --prepare --target-dir=/backup/mariadb ; \
            chown -R mysql:mysql /backup/mariadb"
        - echo "`date` - before_backup completed"
    after_backup:
        - echo "`date` - after_backup started"
    before_prune:
        - echo "`date` - before_prune started"
    after_prune:
        - echo "`date` - after_prune started"

