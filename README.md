# s3_backup

Backup various stuff to S3

## Usage

**Install awscli and setup credentials  and install backup scripts. The access policy only needs to allow PutObject action in backup bucket.**

```puppet
class { 's3_backup':
  aws_access_key_id     => 'XXXXXXXXXXXXXXXXXXXX',
  aws_secret_access_key => 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
  region                => 'eu-central-1',
}
```

**Setup cron to backup /var/log directory every night 1AM**

```puppet
s3_backup::backup_dir_cron { 'backup_log_dir':
  ensure      => present,
  bucket      => 's3://my-bucket',
  target\_dir  => '/var/log',
  identifier  => 'log',
  minute      => '0',
  hour        => '1',
}
```

Once the schedule is executed, it will result in a compressed and timestamped backup archive E.g. s3://my-bucket/log-2015-10-18\_01\_00.tar.xz .


**Setup cron to backup a specific PostgreSQL database 2AM every night**

Once the schedule is executed, it will result in a copressed and timestamped backup archive E.g. s3://my-bucket/pgsql-2015-10-18\_02\_00.psql.tar.xz .

```puppet
s3_backup::backup_pgsql_cron { 'backup_app_database':
  ensure      => present,
  bucket      => 's3://my-bucket',
  database    => 'app',
  minute      => '0',
  hour        => '2',
}
```
