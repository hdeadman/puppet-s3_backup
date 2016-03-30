class s3_backup::install (
  $pip_path = undef,
) {

  # Install awscli (http://docs.aws.amazon.com/cli/latest/reference/index.html#cli-aws)
  exec {  'install_awscli':
    command => "${pip_path} install awscli",
  }

  # Put directory backup script into $PATH
  file {  '/usr/local/bin/s3_backup-backup-dir':
    source => 'puppet:///modules/s3_backup/backup-dir.sh',
    mode   => 'a+x',
  }

  # Put pgsql backup script into $PATH
  file {  '/usr/local/bin/s3_backup-backup-pgsql':
    source => 'puppet:///modules/s3_backup/backup-pgsql.sh',
    mode   => 'a+x',
  }

  # Put auth0 backup script into $PATH
  file {  '/usr/local/bin/s3_backup-backup-auth0':
    source => 'puppet:///modules/s3_backup/backup-auth0.sh',
    mode   => 'a+x',
  }
}
