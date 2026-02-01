# Restic-Backup
A small restic container that uses scripts to make backups.<br>
[Docker Hub](https://hub.docker.com/r/dieeneschrodinger/restic-backup)

Built upon an alpine base with restic, openssh and bash installed as additional utilities.<br>

## Usage:

### Docker compose:
An example of how to use this container is:<br>
```yaml
services:
  restic:
    image: dieeneschrodinger/restic-backup:latest
    container_name: restic
    hostname: backup-container
    environment:
      BACKUP_SCRIPT_PATH: "/data/backup.sh" # Mandatory
      CRON_SCHEDULE: "0 0 4 * * * *" # Mandatory
    volumes:
      - /path/to/script/folder:/data
      - /path/to/backup:/backup:ro # Example path, depends on script
    restart: always
```
This will run the script `/data/backup.sh` every day at 04:00.<br>
The environment variables `BACKUP_SCRIPT_PATH` and `CRON_SCHEDULE` are mandatory. Without these the container will not function.

#### BACKUP_SCRIPT_PATH
This environment variable can be set to any file (or command if you wish to). Upon startup, the container will try to make this file executable.<br>
If this is not a file, the container will give a warning in the logs but not exit.

#### CRON_SCHEDULE
This environment variable can be set to any valid cron schedule with the following syntax:
```
Cron syntax:
* * * * * * *
| | | | | | └ Year
| | | | | └—— Day of week
| | | | └———— Month
| | | └—————— Day of month
| | └———————— Hour
| └—————————— Minute
└———————————— Second

Field name     Mandatory?   Allowed values          Allowed special characters
----------     ----------   --------------          -------------------------
Second         No           0-59                    * / , - L
Minute         Yes          0-59                    * / , -
Hour           Yes          0-23                    * / , -
Day of month   Yes          1-31                    * / , - L W
Month          Yes          1-12 or JAN-DEC         * / , -
Day of week    Yes          0-6 or SUN-SAT          * / , - L #
Year           No           1970–2199               * / , -
```
For more information about how the special characters can be used, see [here](https://github.com/exander77/supertinycron#implementation).

### Docker run:
Docker run is not recommended but can be used, it needs to follow the same rules as docker compose.

Example:
```bash
docker run -d \
  --name restic \
  --hostname backup-container \
  --restart always \
  -e BACKUP_SCRIPT_PATH="/data/backup.sh" \
  -e CRON_SCHEDULE="0 0 4 * * * *" \
  -v /path/to/script/folder:/data \
  -v /path/to/backup:/backup:ro \
  dieeneschrodinger/restic-backup:latest
```

## Planned Features:
- Email notifications
- Config file rather than using a bash script
- Make the container Read-Only

## Acknowledgements:
This container uses the work done by:
[exander77](https://github.com/exander77) through the use of [supertinycron](https://github.com/exander77/supertinycron)
