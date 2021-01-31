class s3_backup (
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $region = undef,
  $pip_path = '/usr/bin/pip',
  $workdir_base = '/tmp',
) {

  validate_string($aws_access_key_id)
  validate_string($aws_secret_access_key)
  validate_string($region)
  validate_string($pip_path)

  # Install awscli (http://docs.aws.amazon.com/cli/latest/reference/index.html#cli-aws)
  class { 's3_backup::install':
    pip_path              => $pip_path,
    workdir_base          => $workdir_base,
  }

  class { 's3_backup::configure':
    aws_access_key_id     => $aws_access_key_id,
    aws_secret_access_key => $aws_secret_access_key,
    region                => $region,
    require               => Class['s3_backup::install'],
  }
}
