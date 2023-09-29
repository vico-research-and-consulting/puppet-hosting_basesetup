# == Class: hosting_basesetup::init
#
# Installs a a basic hosting quality setup
#
# === Parameters
#
# [manage_puppet]
#   Decide to manage puppet by puppet (true/false)
#
# [users]
#   A hashmap which defines a collection of users, check hosting_basesetup::usermanagement::user
#   for details
#
# [glroups]
#   A hashmap which defines a collection of users, check hosting_basesetup::usermanagement::group
#   for details
#
# [ntp_server]
#   A array of ntp servers, specify at least 3 servers
#   (if you have two watches, which one displays the correct time ? :-))
#
# [mosh]
#   decide to install the mosh shell or not (true/false)
#
# [mail_relayhost]
#   a relayhost for the local postfix installation.
#   locally queued mail will be deliver to this host, if this variable is not specified
#   delivery will be perfomed directly
#

class hosting_basesetup (
  Boolean $manage_puppet                       = true,
  Boolean $manage_puppet_set_evironment        = true,
  String $rootpwhash,
  Hash $users                                  = {},
  Hash $users_override                         = {},
  Hash $groups                                 = {},
  Hash $groups_override                        = {},
  Hash $mounts                                 = {},
  Hash $mounts_override                        = {},
  Array[String] $ntp_servers                   = ['ptbtime1.ptb.de', 'ptbtime2.ptb.de', 'ptbtime3.ptb.de', ],
  Boolean $mosh                                = false,
  String $mail_relayhost                       = '',
  String $mail_root_recipient,
  String $mail_domain,
  String $mail_smtp_interfaces                 = '127.0.0.1',
  String $mail_smtp_listen                     = '127.0.0.1',
  Boolean $unattended_upgrades                 = false,
  Boolean $unattended_upgrades_reboot          = false,
  String $unattended_upgrades_reboot_time      = 'now',
  Array[String] $unattended_upgrades_blacklist = [],
  Integer $unattended_upgrades_random_sleep    = 1800,
  String $motd_template                        = "hosting_basesetup/motd.erb",
  String $motd_description                     = "<no description>",
  String $motd_announcement                    = "",
  String $motd_documentation                   = "",
  Variant[String, Enum['no', 'yes']]
  $ssh_password_auth_string                    = 'no',
  #Integer $sshd_config_port                    = 22,
  Stdlib::Port $sshd_config_port               = 22,
  String $sshd_config_subsystem_sftp           = 'USE_DEFAULTS',
  #Hash $sshd_config_match                      = {},
  String $proxy_http_host                      = "",
  String $proxy_http_port                      = "",
  Boolean $proxy_https                         = true,
  Hash $simple_files                           = {},
  Hash $simple_directories                     = {},
  Hash $lvm_snapshots                          = {},
  Boolean $zabbix_agent                        = false,
  String $zabbix_agent_version                 = '1',
  String $puppet_envionment                    = $::environment,
) {

  ## DIR RESSOURCES   ##################################################################
  create_resources("hosting_basesetup::simple_directory", $simple_directories)

  ## FILE RESSOURCES   ##################################################################
  create_resources("hosting_basesetup::simple_file", $simple_files)

  ## KERNEL ##############################################################################
  include ::hosting_basesetup::kernel


  ## MOTD ################################################################################
  file { '/etc/motd':
    ensure  => file,
    content => template($motd_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
  if $facts['os']['name'] == "Ubuntu" {
    file { [ '/etc/cron.weekly/update-notifier-common',
      '/etc/update-motd.d/10-help-text', '/etc/update-motd.d/50-motd-news',
      '/etc/update-motd.d/51-cloudguest', '/etc/update-motd.d/00-header',
      '/etc/update-motd.d/80-livepatch', '/etc/update-motd.d/50-landscape-sysinfo' ]:
      ensure => absent,
    }
  }

  ## CRASH-MANAGEMENT ####################################################################

  include hosting_basesetup::crash_management

  ## SSH #################################################################################
  # TODO: create secure client settings
  include ::ssh

  #class { '::ssh':
  #  forward_agent                        => 'no',
  #  manage_server                        => false,
  #}

  #class { '::ssh::server':
  #  permit_empty_passwords               => 'no',
  #  password_authentication              => $ssh_password_auth_string,
  #  #port                                 => $sshd_config_port,
  #  allow_tcp_forwarding                 => 'no',
  #  x11_forwarding                       => 'no',
  #  use_dns                              => 'no',
  #  kbd_interactive_authentication       => 'no',
  #  use_pam                              => 'yes',
  #  ciphers                              => [ 'aes256-ctr',
  #    'aes192-ctr',
  #    'aes128-ctr' ],
  #  ignore_user_known_hosts              => 'no',
  #  kerberos_authentication              => 'no',
  #  kex_algorithms                       => [ 'diffie-hellman-group-exchange-sha256',
  #    'ecdh-sha2-nistp256',
  #    'ecdh-sha2-nistp384',
  #    'ecdh-sha2-nistp521'],
  #  log_level                            => 'VERBOSE',
  #  login_grace_time                     => 30,
  #  macs                                 => [ 'hmac-sha2-512',
  #    'hmac-sha2-256',
  #    'hmac-sha2-256-etm@openssh.com',
  #    'hmac-sha2-512-etm@openssh.com'],
  #  max_auth_tries                       => 2,
  #  max_sessions                         => 10,
  #  max_startups                         => '10:30:100',
  #  strict_modes                         => 'yes',
  #  print_motd                           => 'no',
  #  subsystem                            => $sshd_config_subsystem_sftp,
  #  #sshd_config_match                    => $sshd_config_match,
  #  permit_root_login                    => 'without-password',
  #  #sshd_config_serverkeybits            => undef,
  #}

  if $mosh {
    ensure_packages(['mosh', ], { 'ensure' => 'present' })
  }

  ## TIME ################################################################################
  class { '::hosting_basesetup::time':
    ntp_servers => $ntp_servers,
  }

  ## POSTFIX #############################################################################
  class { 'postfix':
    # inet_interfaces     => '127.0.0.1, [::1]',
    # smtp_listen         => '127.0.0.1, [::1]',
    inet_interfaces     => $mail_smtp_interfaces,
    smtp_listen         => $mail_smtp_listen,
    myorigin            => $mail_domain,
    root_mail_recipient => $mail_root_recipient,
    relayhost           => $mail_relayhost,
  }

  ## USERMANAGEMENT ######################################################################
  class { '::hosting_basesetup::usermanagement':
    users           => $users,
    users_override  => $users_override,
    groups          => $groups,
    groups_override => $groups_override,
    rootpwhash      => $rootpwhash,
  }

  ## MOUNTPOINTS #########################################################################

  $mountpoints_final = deep_merge($mounts, $mounts_override)
  create_resources("::hosting_basesetup::mount", $mountpoints_final)

  ## SOFTWARE ############################################################################

  include ::hosting_basesetup::packages

  ## NETWORKING ##########################################################################

  class { '::hosting_basesetup::networking':
    before => Class['::hosting_basesetup::dns']
  }
  class { '::hosting_basesetup::dns':
  }

  ## MONITORING ##########################################################################

  if $zabbix_agent {
    include ::hosting_basesetup::monitoring::zabbix_agent
  }

  ## PUPPET AGENT ########################################################################
  if $manage_puppet {
    class { '::puppet_agent':
      service_names => ['puppet'],
    }
    service { 'mcollective':
        ensure     => stopped,
        enable     => false,
        hasstatus  => true,
        hasrestart => true,
    }

    if $manage_puppet_set_evironment {
      file_line { 'set_puppet_environment':
        path    => '/etc/puppetlabs/puppet/puppet.conf',
        line    => "environment = ${puppet_envionment}",
        match   => '^\s*environment\s*=\s*.+',
        require => Class['::puppet_agent'],
      }
      exec { 'restart_agent_set_puppet_environment':
        command     => 'systemctl restart puppet',
        refreshonly => true,
        subscribe   => File_line['set_puppet_environment'],
        path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      }
    }
  }

  ## LVM #################################################################################
  class { '::hosting_basesetup::lvm':
    snapshots => $lvm_snapshots,
  }
  include ::hosting_basesetup::filesystems

  ## PROXY ###############################################################################
  include ::hosting_basesetup::proxy

  ## APT #################################################################################
  include apt

  ## UNATTENDED UPGRADES #################################################################
  if (!$unattended_upgrades) {
    notice("Unattended upgrades are disabled for this system, consider to activate it to improve system security ;-)")
  }
  class { '::hosting_basesetup::unattended_upgrades':
    enable       => $unattended_upgrades,
    reboot       => $unattended_upgrades_reboot,
    reboot_time  => $unattended_upgrades_reboot_time,
    blacklist    => $unattended_upgrades_blacklist,
    random_sleep => $unattended_upgrades_random_sleep,
  }

  ## CRON AND AT #########################################################################
  include ::hosting_basesetup::cron_at

}
