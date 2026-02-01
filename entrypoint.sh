#!/bin/bash

EXIT_FLAG=false

if [ -z "${BACKUP_SCRIPT_PATH}" ]; then
    echo "BACKUP_SCRIPT_PATH not set, exiting container due to missing mandatory variable."
    EXIT_FLAG=true
fi

if [ -z "${CRON_SCHEDULE}" ]; then
    echo "CRON_SCHEDULE not set, exiting container due to missing mandatory variable."
    EXIT_FLAG=true
fi

if [[ "$EXIT_FLAG" == true ]]; then
    exit 0;
fi

chmod a+x "${BACKUP_SCRIPT_PATH}" > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Unable to set backup script to be executable, is the file already executable or is the container/volume read-only?"
fi

/usr/local/bin/supertinycron "${CRON_SCHEDULE}" "${BACKUP_SCRIPT_PATH}"