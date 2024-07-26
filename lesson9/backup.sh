#!/bin/bash

# mysql part
MYSQL_USER="root"
MYSQL_PASSWORD="secret_password"
BACKUP_DIR="/opt/mysql_backup"
BACKUP_FILE="${BACKUP_DIR}/backup_$(date +'%Y-%m-%d_%H-%M-%S').sql"

mysqldump -u ${MYSQL_USER} -p${MYSQL_PASSWORD} --all-databases > ${BACKUP_FILE}
if [ $? -eq 0 ]; then
    echo "Backup successful: ${BACKUP_FILE}"
else
    echo "Backup failed"
    exit 1
fi

# rsync part
REMOTE_USER="vagrant"
REMOTE_HOST="192.168.56.20"
REMOTE_DIR="/opt/store/mysql_backup"

rsync -avz -e "ssh -i /home/vagrant/.ssh/id_rsa" ${BACKUP_DIR}/ ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/
if [ $? -eq 0 ]; then
    echo "Backup file successfully transferred to ${REMOTE_HOST}:${REMOTE_DIR}"
else
    echo "Failed to transfer backup file"
    exit 1
fi

