class s3_backup::install (
  $pip_path = undef,
  $workdir_base = '/tmp'
) {

  # Install awscli (http://docs.aws.amazon.com/cli/latest/reference/index.html#cli-aws)
  exec {  'install_awscli':
    command => "${pip_path} install awscli",
  }

  # Put directory backup script into $PATH
  file {  '/usr/local/bin/s3_backup-backup-dir':
    content => template("${module_name}/backup-dir.sh"),
    mode   => 'a+x',
  }

  # Put pgsql backup script into $PATH
  file {  '/usr/local/bin/s3_backup-backup-pgsql':
    content => template("${module_name}/backup-pgsql.sh"),
    mode   => 'a+x',
  }

  # Put auth0 backup script into $PATH
  file {  '/usr/local/bin/s3_backup-backup-auth0':
    content => template("${module_name}/backup-auth0.sh"),
    mode   => 'a+x',
  }
}
