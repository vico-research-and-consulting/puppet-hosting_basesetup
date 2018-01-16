class hosting_basesetup::kernel (
  String $sysctl_filename        = '/etc/sysctl.conf',
  Hash $sysctl_config          = {
  }
  ,
  Boolean $sysctl_enable_fastnetworking_defaults = false,
  Boolean $sysctl_ignore_defaults = true,) {
  # Sysctl reload
  file { 'sysctl_conf': name => $sysctl_filename, }

  exec { 'sysctl_file_load':
    command     => 'sysctl -p',
    refreshonly => true,
    subscribe   => File['sysctl_conf'],
    path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  }

  $sysctl_stdkernel = {
    'kernel.panic'         => {
      'value'                => 30
    }
    ,
    'kernel.panic_on_oops' => {
      'value'                => 30
    }
    ,
    'vm.panic_on_oom'      => {
      'value'                => 1
    }
    ,
    'vm.swappiness'        => {
      'value'                => 0
    }
    ,
    'fs.aio-max-nr'        => {
      'value'                => 262144
    }
    ,
    'fs.file-max'          => {
      'value'                => 1000000
    }
    ,
  }

  #################################################################################
  # # Settings for 10G NIC, optimized for network paths up to 100ms RTT,
  if $sysctl_enable_fastnetworking_defaults {
    notice("Enabling networking settings for 10g equipment")
    $sysctl_fastnetworking_defaults = {
      'net.ipv4.tcp_syncookies'     => {
        'value' => 1
      }
      ,
      'net.core.rmem_max'           => {
        'value' => 16777216
      }
      ,
      'net.core.wmem_max'           => {
        'value' => 16777216
      }
      ,
      'net.ipv4.tcp_rmem'           => {
        'value' => '4096 87380 16777216'
      }
      ,
      'net.ipv4.tcp_wmem'           => {
        'value' => '4096 65536 16777216'
      }
      ,
      'net.core.netdev_max_backlog' => {
        'value' => '30000'
      }
      ,
      'net.ipv4.tcp_mtu_probing'    => {
        'value' => '1'
      }
      ,
    }
  } else {
    $sysctl_fastnetworking_defaults = {
    }
  }

  if $sysctl_ignore_defaults {
    $sysctl_config_final = $sysctl_config
  } else {
    $sysctl_config_final = deep_merge($sysctl_stdkernel, $sysctl_config, $sysctl_fastnetworking_defaults)
  }
  create_resources('hosting_basesetup::kernel::sysctl', $sysctl_config_final)
}
