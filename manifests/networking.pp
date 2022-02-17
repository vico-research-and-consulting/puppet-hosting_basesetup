class hosting_basesetup::networking (
  Boolean $disable_netplan = false,
  String $nameserver_searchdomain = "",
  Hash $netplanconfig = {},
  Array[String] $nameservers = [],
) {
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
    if ($netplanconfig != {}) {
      create_resources('hosting_basesetup::netplanconfigbuilder', $netplanconfig)
    }
  }

}
