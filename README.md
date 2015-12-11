# s3\_backup

Backup various stuff to S3

## Usage

**Install and configure**

Install [awscli](https://aws.amazon.com/cli/), setup credentials and install backup scripts. The access policy only needs to allow PutObject action in backup bucket.

```puppet
class { 's3_backup':
  aws_access_key_id     => 'XXXXXXXXXXXXXXXXXXXX',
  aws_secret_access_key => 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
  region                => 'eu-central-1',
}
```

**Setup cron to backup /var/log directory 1AM, every night**

```puppet
s3_backup::backup_dir_cron { 'backup_log_dir':
  ensure      => present,
  bucket      => 's3://my-bucket',
  target_dir  => '/var/log',
  identifier  => 'log',
  minute      => '0',
  hour        => '1',
}
```

Once the schedule is executed, it will result in a compressed and timestamped backup archive E.g. `s3://my-bucket/log-2015-10-18_01_00.tar.xz` .


**Setup cron to backup a specific PostgreSQL database 2AM, every night**

```puppet
s3_backup::backup_pgsql_cron { 'backup_app_database':
  ensure      => present,
  bucket      => 's3://my-bucket',
  database    => 'app',
  minute      => '0',
  hour        => '2',
}
```

Once the schedule is executed, it will result in a compressed and timestamped backup archive E.g. `s3://my-bucket/app-2015-10-18_02_00.psql.tar.xz` .

**Backup auth0 users 2AM, every night**

```puppet
s3_backup::backup_auth0_cron { 'backup_auth0_users':
  ensure      => present,
  bucket      => 's3://my-bucket',
  domain      => 'xxxxxx.auth0.eu',
  token       => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  minute      => '0',
  hour        => '2',
}
```


===================
<br/>
<a href="http:fadeit.dk"><img src="http://fadeit.dk/src/assets/img/brand/fadeit_logo_full.svg" alt="The fadeit logo" style="width:200px;"/></a><br/><br/>

####About fadeit
We love and are really good at designing &amp; developing beautiful software, web and mobile applications.

See more at [fadeit.dk](http://fadeit.dk)
