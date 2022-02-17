class hosting_basesetup::networking (
  Boolean $disable_netplan = false,
  Hash $netplanconfig,
) {
    define hosting_basesetup::networking::netplanconfigbuilder (
      String $ensure                                          = present,
      String $ip,
      String $gateway,
      Hash $interface_associations,
      Hash $interface,
    ) {

      if($interface_associations) {
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


  if ($disable_netplan) {
    if ($facts['os']['name'] == 'Ubuntu') and ($facts['os']['release']['full'] == "18.04" ) {
      ensure_packages(['ifupdown', 'resolvconf' , 'vlan', 'ifenslave'], { ensure => present })
      service { 'networkd-dispatcher':
        ensure => stopped,
        enable => mask,
      }
      ensure_packages(['netplan.io'], { ensure => absent })
    }else {
      notice('disabling netplan is not supported for this distribution')
    }
  }
  else {
    create_resources('hosting_basesetup::networking::netplanconfigbuilder', $netplanconfig)
  }

}
