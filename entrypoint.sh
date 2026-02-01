#!/bin/bash

EXIT_FLAG=false

echo "Restic-Backup v0.1.0"
echo "Documentation at: https://github.com/DieEneSchrodinger/Restic-Backup"
echo ""

if [ -z "${BACKUP_SCRIPT_PATH}" ]; then
    echo "BACKUP_SCRIPT_PATH not set, exiting container due to missing mandatory variable." >&2
    EXIT_FLAG=true
fi

if [ -z "${CRON_SCHEDULE}" ]; then
    echo "CRON_SCHEDULE not set, exiting container due to missing mandatory variable." >&2
    EXIT_FLAG=true
fi

if [[ "$EXIT_FLAG" == true ]]; then
    exit 1;
fi

echo "Backup path: ${BACKUP_SCRIPT_PATH}"
echo "Backup schedule: ${CRON_SCHEDULE}"

chmod a+x "${BACKUP_SCRIPT_PATH}" > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Unable to set backup script to be executable, is the file missing or is the container/volume read-only?" >&2
fi

exec /usr/local/bin/supertinycron "${CRON_SCHEDULE}" "${BACKUP_SCRIPT_PATH}"