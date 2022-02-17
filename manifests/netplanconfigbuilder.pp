define hosting_basesetup::netplanconfigbuilder (
  String $interface                                        = $title,
  String $ensure                                          = present,
  String $ip,
  String $gateway,
  Hash $interface_associations = {},
) {

  if($interface_associations != {}) {
    file { '/etc/netplan/01-netcfg.yaml':
      ensure  => $ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      backup  => true,
      content => template('hosting_basesetup/netplan_assoc.yaml.erb'),
    }
  } else {
    file { '/etc/netplan/01-netcfg.yaml':
      ensure  => $ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      backup  => true,
      content => template('hosting_basesetup/netplan.yaml.erb'),
    }
  }
}