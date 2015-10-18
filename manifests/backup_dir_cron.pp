define s3_backup::backup_dir_cron (
  $ensure = 'present',
  $bucket = undef,
  $target_dir = undef,
  $identifier = undef,
  $minute   = '*',
  $hour     = '*',
  $weekday  = '*',
  $monthday = '*',
  $month    = '*',
) {
  validate_string($bucket)
  validate_string($target_dir)
  validate_string($identifier)


  cron { "${title}_backup_dir_cron":
    ensure      => $ensure,
    command     =>  "/usr/local/bin/s3_backup-backup-dir --bucket='${bucket}' --dir='${target_dir}' --identifier='$identifier'",
    minute      => $minute,
    hour        => $hour,
    weekday     => $weekday,
    monthday    => $monthday,
    month       => $month,
  }
}
