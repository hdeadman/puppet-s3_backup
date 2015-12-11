define s3_backup::backup_auth0_cron (
  $ensure = 'present',
  $bucket = undef,
  $domain = undef,
  $token = undef,
  $minute   = '*',
  $hour     = '*',
  $weekday  = '*',
  $monthday = '*',
  $month    = '*',
) {
  validate_string($bucket)
  validate_string($domain)
  validate_string($token)


  cron { "${title}_backup_auth0_cron":
    ensure   => $ensure,
    command  => "/usr/local/bin/s3_backup-backup-auth0 --bucket='${bucket}' --domain='${domain}' --token='${token}'",
    minute   => $minute,
    hour     => $hour,
    weekday  => $weekday,
    monthday => $monthday,
    month    => $month,
  }
}
