# Setup aws user (can be found at /root/.aws)
class s3_backup::configure (
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $region = undef,
) {

  exec {  'configure_aws_access_key_id':
    command => "/usr/local/bin/aws configure set aws_access_key_id ${aws_access_key_id}"
  }

  exec {  'configure_aws_secret_access_key':
    command => "/usr/local/bin/aws configure set aws_secret_access_key ${aws_secret_access_key}"
  }

  exec {  'configure_aws_region':
    command => "/usr/local/bin/aws configure set region ${region}"
  }
}
