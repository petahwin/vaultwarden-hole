#!/usr/bin/env bash

set -euo pipefail

SCRIPT_PATH=$(dirname $(realpath -s $0))
RECIPIENT="${RECIPIENT}"
DATE="$(date +%Y%m%d)"
BACKUP_FILE_PATH="/tmp/${DATE}_backup.asc"
BW_SERVER_DATA_PATH="/opt/bitwarden/bw-data"
DATA_DIR_NAME=$(basename $BW_SERVER_DATA_PATH)
SERVICE_ACCOUNT_KEYPATH="${SERVICE_ACCOUNT_PATH}"
GDRIVE_FOLDER_ID="${FOLDER_ID}"

# # Pull encrypted data from bitwarden server
# Export the encrypted data that doesn't require access to master password
# Ref: https://github.com/bitwarden/clients/issues/2739#:~:text=By%20contrast%2C%20the,manually%20during%20restore.
# Doesn't work, when attempting to unlock the data.json afterwards, it fails
# because of a requirement to check in with a server first before completing auth
# BW_EXEC="bw-cli"
# ${BW_EXEC} config server "${BW_HOST}" && \
#   (${BW_EXEC} logout; ${BW_EXEC} login --apikey) && \
#   ${BW_EXEC} sync
# ${BW_EXEC} logout

# Copy entire bitwarden server image
cp -r ${BW_SERVER_DATA_PATH} /tmp
CONTENTS="$(cd /tmp && tar czf - ${DATA_DIR_NAME} | base64)"
rm -r /tmp/${DATA_DIR_NAME}

# Encrypt the data again (with gpg key) and write to file
echo "Backing up data to '${BACKUP_FILE_PATH}'"
echo "${CONTENTS}" | base64 -d | \
 gpg \
 --encrypt \
 --armor \
 --trust-model always \
 --recipient "${RECIPIENT}" \
> "${BACKUP_FILE_PATH}"

# Upload to Google Drive
source ${SCRIPT_PATH}/.venv/bin/activate
echo "Uploading to Google Drive..."
python3 ${SCRIPT_PATH}/upload.py ${SERVICE_ACCOUNT_KEYPATH} ${BACKUP_FILE_PATH} ${GDRIVE_FOLDER_ID}
echo "Done"

rm ${BACKUP_FILE_PATH}
