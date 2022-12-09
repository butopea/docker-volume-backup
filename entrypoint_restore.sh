#!/bin/sh

set -e

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
#  exec restore. If mounted volume empty, it will automatically restore from backup
exec restore
else
  echo "No AWS keys found. No restore from AWS S3 possible."
fi

# Call original entrypoint script from upstream image
exec /root/entrypoint.sh "$@"