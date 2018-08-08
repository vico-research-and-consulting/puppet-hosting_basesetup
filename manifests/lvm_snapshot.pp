define hosting_basesetup::lvm_snapshot (
  String $lv_name           = $title,
  String $cron_timespec     = "0 3 * * *",
  Boolean $snap_create      = true,
  String  $snap_size        = "10%",
  Boolean $snap_delete      = true,
  Integer $snap_generations = 3,
  Boolean $zabbix_notify    = false,
  String $ensure            = present,
) {
  $title_simple = regsubst($title, '/', '_', 'G')

  if $zabbix_notify {
    $zabbix = "--zabbix_notify"
  }else {
    $zabbix = ""
  }

  if $snap_create {
    $snap = "--snap --lv_size '${snap_size}'"
  }else {
    $snap = ""
  }

  if $snap_purge {
    $purge = "--delete_snaps --max_snaps $snap_generations "
  }else {
    $purge = ""
  }

  file { "/etc/cron.d/lvm_snapshot_${title_simple}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "# created by puppet
${cron_timespec} /usr/local/sbin/manage_lvm_snapshots ${snap} ${purge} ${zabbix} ${lv_name} 2>&1|logger -t lvm_snapshot
",
  }
}
