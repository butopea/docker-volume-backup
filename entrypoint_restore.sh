#!/bin/sh

set -e

#if [ -z "${AUTHORIZED_KEYS}" ]; then
#  echo "Need your ssh public key as AUTHORIZED_KEYS env variable. Abnormal exit ..."
#  exit 1
#fi


# We export AWS credentials passed as Swarm secrets
AWS_ACCESS_KEY_ID=$(cat ${AWS_ACCESS_KEY_ID_FILE})
AWS_SECRET_ACCESS_KEY=$(cat ${AWS_SECRET_ACCESS_KEY_FILE})
## Configure AWS CLI config file
if [ ! -z "$AWS_ACCESS_KEY_ID" ]; then
  mkdir -p .aws
  cat <<EOF > .aws/credentials
[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}
EOF
#  exec restore
else
  echo "No AWS keys found. No restore from AWS S3 possible."
fi

# Call original entrypoint script from upstream image
exec /root/entrypoint.sh "$@"