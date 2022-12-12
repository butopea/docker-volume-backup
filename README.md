# Docker Volume Backup

This image extends the offer/docker-volume-backup docker image and adds possibility to restore and download backups from AWS S3.

## Config
Create `docker-compose.yml` file to add config variables. Check syntax below for more 
information. For configuration options, see [official docs](https://github.com/offen/docker-volume-backup/blob/main/README.md).

```yaml
version: '3.8'
services:
 docker-volume-backup:
    image: butopea/docker-volume-backup:latest
    environment:
      BACKUP_FILENAME: odoo-web-data-backup.tar.gz
      BACKUP_EXCLUDE_REGEXP: \.sess$$
      BACKUP_SOURCES: /odoo-web-data
      AWS_S3_BUCKET_NAME: production-backups-bp
      AWS_S3_PATH: odoo-volumes-backup
      AWS_ENDPOINT: s3.eu-central-003.backblazeb2.com
      AWS_ACCESS_KEY_ID_FILE: /run/secrets/aws_s3_backblaze_backups_access_key
      AWS_SECRET_ACCESS_KEY_FILE: /run/secrets/aws_s3_backblaze_backups_secret_key
    volumes:
      # Depending on if you want to restore or only backup, you either mount it read-only or read/write
      # Script only restores if directory is empty.
      - odoo-web-data:/odoo-web-data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
    secrets:
     - aws_s3_backblaze_backups_access_key
     - aws_s3_backblaze_backups_secret_key  
secrets: # Feature of Docker Swarm. For local env one can define a simple text file.
  aws_s3_backblaze_backups_access_key:
    # On Bitwarden, you can find either production password or development password
    file: aws_s3_backblaze_backups_access_key.txt
  aws_s3_backblaze_backups_secret_key:
    # Format of credential file see https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
    file: aws_s3_backblaze_backups_secret_key.txt
volumes:
  odoo-web-data:
    external: true
```
## Main Commands

### Backup
You can manually trigger a backup run outside of the defined cron schedule by executing the `backup` command inside the container:
```
docker exec <container_ref> backup
```

### Restore
Restoration is happening automatically after each start of container if mounted directory is empty.
You can manually trigger a restore (if directory is empty) by executing the `restore` command inside the container:
```
docker exec <container_ref> restore
```
> **Note**
> Restoration command assumes that you want to extract the content of backup directory excluding main directory.
> Useful for volume restoration.