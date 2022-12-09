# Docker Volume Backup

This image extends the offer/docker-volume-backup docker image and adds possibility to restore and download backups from AWS S3.
For configuration options, see [official docs](https://github.com/offen/docker-volume-backup/blob/main/README.md).

## Config
Create `docker-compose.yml` file to add config variables. Check syntax below for more 
information

```yaml
version: '3.8'
services:
  db:
    image: butopea/odoo-db:10 # PostgreSql version as tag
    environment:
      PGDATA: /var/lib/postgresql/data/pgdata
      POSTGRES_DB: postgres
      POSTGRES_USER: odoo
      POSTGRES_PASSWORD_FILE: /run/secrets/odoo_erp_prod_db_password
      BACKUP_FILENAME: pg_dumpall_all.sql.gz # Verify backup file
      AWS_S3_BUCKET_NAME: production-backups-bp/odoodb # Verify Bucket Name
      AWS_EXTRA_ARGS: --endpoint-url https://s3.eu-central-003.backblazeb2.com # Verify most up to date endpoint
      AWS_SHARED_CREDENTIALS_FILE: /run/secrets/aws_s3_config_file
    ports:
      - 5432:5432
    volumes:
      - odoo-db-data:/var/lib/postgresql/data/pgdata
    secrets:
      - odoo_erp_prod_db_password
      - aws_s3_config_file_backblaze_backups
secrets: # Feature of Docker Swarm. For local env one can define a simple text file.
  odoo_erp_prod_db_password:
    # On Bitwarden, you can find either production password or development password
    file: odoo_erp_prod_db_password.txt
  aws_s3_config_file:
    # Format of credential file see https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
    file: aws_s3_config_file.txt
volumes:
  odoo-db-data:
    external: true
```
## Main Commands

### Backup

### Restore
