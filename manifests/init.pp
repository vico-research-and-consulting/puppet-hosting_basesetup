# == Class: hosting_basesetup::init
#
class hosting_basesetup(
  Hash $users = {},
  Hash $groups = {},
  Array[String] $ntp_servers = [ 'ptbtime1.ptb.de', 'ptbtime2.ptb.de', 'ptbtime3.ptb.de', ],
  Boolean $mosh = False,
  String $mail_relayhost = '',
  String $rootpwhash,
  String $mail_root_recipient,
  String $mail_domain,
  String $motd_template = "hosting_basesetup/motd.erb",
  String $motd_description = "<no description>",
){
  ## RESSOURCE ORDERING ##################################################################
  class { '::ssh_hardening::client':} ->
  class { '::ssh_hardening::server':}

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

  ## SSH #################################################################################
  include ::ssh_hardening::server
  include ::ssh_hardening::client

  if $mosh {
    ensure_packages( ['mosh',], {'ensure' => 'present'})
  }

  ## TIME ################################################################################
	class { '::hosting_basesetup::time':
    ntp_servers => $ntp_servers,
  }

  ## POSTFIX #############################################################################
	class { 'postfix':
     inet_interfaces => '127.0.0.1',
     smtp_listen => '127.0.0.1',
     #inet_interfaces => '127.0.0.1, [::1]',
     #smtp_listen => '127.0.0.1, [::1]',
     myorigin => $mail_domain,
     root_mail_recipient => $mail_root_recipient,
     relayhost => $mail_relayhost,
  }

  ## USERMANAGEMENT #########################################################################
 	class { '::hosting_basesetup::usermanagement':
    groups => $groups,
    users => $users,
    rootpwhash => $rootpwhash,
  }

  ## SOFTWARE ############################################################################
  class { '::hosting_basesetup::packages': }
}
