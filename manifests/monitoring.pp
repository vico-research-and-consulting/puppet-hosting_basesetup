class hosting_basesetup::monitoring(
    Boolean $zabbix_agent = true,
    String $zabbix_server = 'zabbix',
    String $zabbix_server_active = 'zabbix',
    String $zabbix_listenip = '127.0.0.1',
) {
  if $zabbix_agent {
			class { 'zabbix::agent':
				server => "${zabbix_server}, 127.0.0.1",
				serveractive => $zabbix_server,
        listenip => $zabbix_listenip,
        buffersize => 500,
        hostmetadata => $zabbix_hostmetadata,

			}
      include zabbix::sender
      ensure_packages([ "zabbix-get" ])
  }
}

