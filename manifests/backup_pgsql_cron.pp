define s3_backup::backup_pgsql_cron (
  $ensure = 'present',
  $bucket = undef,
  $database = undef,
  $minute   = '*',
  $hour     = '*',
  $weekday  = '*',
  $monthday = '*',
  $month    = '*',
) {
  validate_string($bucket)
  validate_string($database)


  # Cleans all files older than 5 days from TMP
  cron { "${title}_backup_dir_cron":
    ensure      => $ensure,
    command     =>  "/usr/local/bin/s3_backup-backup-pgsql --bucket='${bucket}' --database='${database}'",
    minute      => $minute,
    hour        => $hour,
    weekday     => $weekday,
    monthday    => $monthday,
    month       => $month,
  }
}
