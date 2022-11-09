class hosting_basesetup::monitoring::zabbix_agent (
  String $version                          = '3.4',
  String $package_state                    = 'present',
  Boolean $manage_repo                     = true,
  String $server                           = 'zabbix',
  String $server_active                    = 'zabbix',
  String $listenip                         = '127.0.0.1',
  String $hostmetadata                     = '|Linux|Puppet|',
  Array[String] $additional_agent_packages = [],
  Integer $unsafe_parameters               = 0,
  String $additional_agent_packages_ensure = 'installed',
  Boolean $use_agent_extensions            = false,
  String  $use_agent_extensions_pkgname    = 'zabbix-agent-extensions',
  String  $use_agent_extensions_release    = 'present',
  String $load_module_path                 = '/usr/lib/zabbix/modules',
  String $zabbix_agent_version             = $hosting_basesetup::zabbix_agent_version,
  Hash $template_params                    = {},
) {

  if $zabbix_agent_version == '2' {
    $zabbix_agent_pkgname    = 'zabbix-agent2'
    $zabbix_agent_service    = 'zabbix-agent2'
    $zabbix_agent_conffile   = '/etc/zabbix/zabbix_agent2.conf'
    $zabbix_agent_confdir    = '/etc/zabbix/zabbix_agent2.d'
    $template                = 'hosting_basesetup/zabbix_agent2.conf.erb'
    $include_dir_purge       = false
  }elsif $zabbix_agent_version == '1' {
    $zabbix_agent_pkgname    = 'zabbix-agent'
    $zabbix_agent_service    = 'zabbix-agent'
    $zabbix_agent_conffile   = '/etc/zabbix/zabbix_agentd.conf'
    $zabbix_agent_confdir    = '/etc/zabbix/zabbix_agentd.d'
    $template                = 'hosting_basesetup/zabbix_agentd.conf.erb'
    $include_dir_purge       = true
  }

  if $use_agent_extensions {
    # ensure that this package is part of the package repos
    ensure_packages([$use_agent_extensions_pkgname],
      {
        'ensure'  => $use_agent_extensions_release,
        'require' => Package[$zabbix_agent_pkgname],
        'before'  => [ File[$zabbix_agent_conffile], Service[$zabbix_agent_service], ]
      }
    )
    file { '/etc/sudoers.d/zabbix':
      ensure  => present,
      mode    => '0440',
      owner   => 'root',
      group   => 'root',
      require => Package[$use_agent_extensions_pkgname],
    }

    # Include dir for specific zabbix-agent checks.
    file { "$zabbix_agent_confdir/zabbix-agent-extensions.conf":
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => '# Maintained by puppet
Include=/usr/share/zabbix-agent-extensions/include.d/
 ',
      notify  => Service[$zabbix_agent_service],
      require => File[$zabbix_agent_confdir]
    }
  }

  $zabbix_packages = [$zabbix_agent_pkgname, 'zabbix-sender']
  if $manage_repo {
    class { '::hosting_basesetup::monitoring::zabbix_repo':
      zabbix_version => $version,
    }

    case $facts['os']['family'] {
      'Debian': {
        package { $zabbix_packages:
          ensure => $package_state,
          require => [Class['::hosting_basesetup::monitoring::zabbix_repo'], Class['apt::update']],
        }
      }
      'RedHat': {
        package { $zabbix_packages:
          ensure => $package_state,
          require => Class['::hosting_basesetup::monitoring::zabbix_repo']
        }
      }
      default: { notify { "The OS family ${facts['os']['family']} is not supported by this module": } }
    }

  }else {
    package { $zabbix_packages:
      ensure => $package_state,
    }
  }

  file { $zabbix_agent_confdir:
    ensure  => directory,
    owner   => 'zabbix',
    group   => 'zabbix',
    recurse => true,
    purge   => $include_dir_purge,
    notify  => Service[$zabbix_agent_service],
    require => Package[$zabbix_agent_pkgname]
  }
  -> file { "$zabbix_agent_confdir/plugins.d":
      ensure => directory,
      mode   => '0755',
      owner => 'zabbix',
      group => 'zabbix',
  }
  file { $zabbix_agent_conffile:
    ensure  => present,
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => '0644',
    notify  => Service[$zabbix_agent_service],
    require => Package[$zabbix_agent_pkgname],
    replace => true,
    content => template($template),
  }

  service { $zabbix_agent_service:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [ Package[$zabbix_agent_pkgname], File[$zabbix_agent_conffile]],
  }

  ensure_packages(
    $additional_agent_packages, { 'ensure' => $additional_agent_packages_ensure, }
  )
}

