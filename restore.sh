#!/bin/sh

set -e

# Check if env variables are set
BACKUP_SOURCES=${BACKUP_SOURCES:-/backup}

# check if volume backup data is not empty
data_dir_empty=false
if [ "$(ls -A ${BACKUP_SOURCES})" ]; then
   echo "${BACKUP_SOURCES} is not empty! No auto restoration. Delete content of mounted volume first."
else
  echo "${BACKUP_SOURCES} is empty. Begin restore of backup."
  data_dir_empty=true
fi

# If docker volume dir is empty, restore files from backup
# specified by env variables AWS_S3_ENDPOINT, AWS_S3_BUCKET_NAME and
# BACKUP_FILENAME
# Access key and secret key for S3 Endpoint in credentials file needed

# Only execute if restore path is empty
if [ "$data_dir_empty" = true ] ; then

  start=$(date +%s)
  # If AWS_S3_PATH not empty, add slash
  if [ -n "$AWS_S3_PATH" ]; then AWS_S3_PATH="/${AWS_S3_PATH}"; fi
  echo "INFO" "Downloading file ${BACKUP_FILENAME} to temp location"
  aws --endpoint-url https://${AWS_ENDPOINT} s3 cp "s3://${AWS_S3_BUCKET_NAME}${AWS_S3_PATH}/${BACKUP_FILENAME}" /tmp/${BACKUP_FILENAME}
  end=$(date +%s)
  download=$((end-start))
  echo "INFO" "Downloaded in ${download} seconds."

  start=$(date +%s)
  echo "INFO" "Extracting data to ${BACKUP_SOURCES}"
  tar --strip-components=1 -C ${BACKUP_SOURCES} -xzf /tmp/${BACKUP_FILENAME} ${BACKUP_SOURCES:1}
  end=$(date +%s)
  restored=$((end-start))
  echo "INFO" "Extracted in ${restored} seconds."

  rm -f /tmp/${BACKUP_FILENAME}
fi