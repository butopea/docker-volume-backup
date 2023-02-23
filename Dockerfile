FROM offen/docker-volume-backup:v2
MAINTAINER Butopêa <alex@butopea.com>

RUN apk add --no-cache aws-cli

WORKDIR /root
COPY ./entrypoint_restore.sh /root/entrypoint_restore.sh
RUN chmod +x entrypoint_restore.sh

COPY ./restore.sh /usr/bin/restore
RUN chmod +x /usr/bin/restore

# Replace original entrypoint. However, we call within our script the original script after we have finished.
ENTRYPOINT ["/root/entrypoint_restore.sh"]
