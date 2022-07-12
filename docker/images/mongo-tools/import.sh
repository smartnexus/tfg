#!/bin/bash
echo "Starting to backup all collections..."
FILE=/backup/mongodump.gz

if [ "$RESTORE_ENV" == "yes" ]; then 
	if test -f "$FILE"; then
		mongorestore --host $WAIT_FOR --archive="$FILE" --gzip
 		echo "Database backup done!"
	else
		echo "Mongodump file not found!"
	fi
else 
	echo "Database not empty or backup does not exists"
fi