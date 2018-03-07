class hosting_basesetup::kernel::sysfs (
  Boolean $transparent_hugepages_off = true,
  Hash $sysfs_config                 = $::hosting_basesetup::kernel::sysfs_config,
  Boolean $sysfs_ignore_defaults     = $::hosting_basesetup::kernel::sysfs_ignore_defaults,
  Hash $items                        = {}
) {


  if $transparent_hugepages_off {
    $sysfs_transparent_hugepages_off = {
      'kernel/mm/transparent_hugepage/defrag'  => 'never',
      'kernel/mm/transparent_hugepage/enabled' => 'never',
    }
  }else {
    $transparent_hugepages_off = {}
  }

  if $sysfs_ignore_defaults {
    $sysfs_config_final = $sysfs_config
  } else {
    $sysfs_config_final = deep_merge(
      $sysfs_transparent_hugepages_off,
      $sysfs_config,
    )
  }

  case $::operatingsystem {
    'ubuntu', 'debian': {

      ensure_packages(['sysfsutils'])

      ####################################################################################
      # see: https://bugs.launchpad.net/ubuntu/+source/sysfsutils/+bug/1754033
      # (can be removed if this problem is solved)
      file { '/etc/init.d/sysfsutils':
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/hosting_basesetup/sysfsutils',
        require => Package['sysfsutils'],
      }
      exec { 'sysfs_initscript_load':
        command     => 'systemctl daemon-reload',
        refreshonly => true,
        subscribe   => File['/etc/init.d/sysfsutils'],
        path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      }
      #
      ####################################################################################

      file { "/etc/sysfs.conf":
        alias   => 'syscfs_conf',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("hosting_basesetup/sysfs.conf.erb"),
      }

      service { 'sysfsutils':
        ensure     => running,
        enable     => true,
        hasstatus  => false,
        hasrestart => true,
        subscribe  => [File['/etc/init.d/sysfsutils'], File['syscfs_conf']],
      }

      file { '/etc/sysfs.d':
        ensure  => 'directory',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        backup  => false,
        recurse => true,
        purge   => true,
      }
      create_resources("hosting_basesetup::kernel::sysfs_item", $items)
    }

    'Centos': {
      fail("unsupported os: ${::operatingsystem}")
    }
    default: {
      fail("unsupported os: ${::operatingsystem}")
    }
  }

  ############################################################################################################


}