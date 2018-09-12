class hosting_basesetup::monitoring::zabbix_agent (
  String $version                          = "present",
  Boolean $manage_repo                     = true,
  String $server                           = 'zabbix',
  String $server_active                    = 'zabbix',
  String $listenip                         = '127.0.0.1',
  String $hostmetadata                     = '|Linux|Puppet|',
  Array[String] $additional_agent_packages = [],
  String $additional_agent_packages_ensure = 'installed',
  Boolean $use_agent_extensions            = false,
  String  $use_agent_extensions_pkgname    = 'zabbix-agent-extensions',
  String  $use_agent_extensions_release    = 'present',
) {

  if $use_agent_extensions {
    # ensure that this package is part of the package repos
    ensure_packages([$use_agent_extensions_pkgname],
      {
        'ensure'  => $use_agent_extensions_release,
        'require' => Class['zabbix::agent'],
        'before'  => [ File['/etc/zabbix/zabbix_agentd.conf'], Service['zabbix-agent'], ]
      }
    )
    file { '/etc/sudoers.d/zabbix':
      ensure => present,
      mode   => '0440',
      owner  => 'root',
      group  => 'root',
    }
    file { '/etc/zabbix/zabbix_agentd.d/zabbix-agent-extensions':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => '# Maintained by puppet
Include=/usr/share/zabbix-agent-extensions/include.d/
 ',
      notify  => Service['zabbix-agent'],
    }
  }

  if $manage_repo {
    class { '::hosting_basesetup::monitoring::zabbix_repo':
      zabbix_version     => $version,
      before      => [ Package['zabbix-agent'], Package['zabbix-sender'] ],
    }
  }
  package { "zabbix-agent":
    ensure  => "$version",
  }
  package { 'zabbix-sender':
    ensure  => "$version",
  }

  package { 'zabbix-get':
    ensure  => "$version",
  }

  file { '/etc/zabbix/zabbix_agentd.conf':
    ensure  => present,
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => '0644',
    notify  => Service['zabbix-agent'],
    require => Package['zabbix-agent'],
    replace => true,
    content => template('hosting_basesetup/zabbix_agentd.conf.erb'),
  }

  service { 'zabbix-agent':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [ Package['zabbix-agent'], File['/etc/zabbix/zabbix_agentd.conf']],
  }

  ensure_packages(
    $additional_agent_packages, { 'ensure'  => $additional_agent_packages_ensure, }
  )
}
