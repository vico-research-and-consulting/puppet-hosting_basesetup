define hosting_basesetup::kernel::sysctl (String $ensure = 'present', $value) {
  $context = '/files/etc/sysctl.conf'

  if $ensure == 'present' {
    augeas { "sysctl_conf/${title}":
      context => $context,
      onlyif  => "get ${title} != '${value}'",
      changes => "set ${title} '${value}'",
      notify  => Exec['sysctl_file_load'],
    }
  } else {
    augeas { "sysctl_conf/${title}":
      context => $context,
      changes => "rm ${title}",
      notify  => Exec['sysctl_file_load'],
    }
  }
}

