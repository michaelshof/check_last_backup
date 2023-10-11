#!/bin/sh

LAST_BACKUP_LOG="/var/log/backup-scripts.log"

KEY=""
VALUE="UNDEFINED"
for WORD in $(cat ${LAST_BACKUP_LOG}); do
	if [ -z "${KEY}" ]; then
		KEY=${WORD}
		VALUE=""
	else
		VALUE=${WORD}
		export ${KEY}=${VALUE}
		KEY=""
	fi
done

if [ -z "${backup_start_at}" ]; then
	echo "UNKNOWN - missing backup_start_at in ${LAST_BACKUP_LOG}"
	exit 3
fi
if [ -z "${backup_end_at}" ]; then
	echo "UNKNOWN - missing backup_end_at in ${LAST_BACKUP_LOG}"
	exit 3
fi
if [ -z "${backup_exit_code}" ]; then
	echo "UNKNOWN - missing backup_exit_code in ${LAST_BACKUP_LOG}"
	exit 3
fi

BACKUP_DURATION=$(echo "${backup_end_at} - ${backup_start_at}" |bc)
OUTOUT="duration=${BACKUP_DURATION}s"
PERF_DATA="'duration'=${BACKUP_DURATION}s 'exit_code'=${backup_exit_code}"

if [ ${backup_exit_code} -eq 0 ]; then
	echo "OK - ${OUTOUT} | ${PERF_DATA}"
	exit 0
else
	echo "CRITICAL - ${OUTOUT} | ${PERF_DATA}"
	exit 2
fi
