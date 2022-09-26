class hosting_basesetup::dns () {

  if $facts['os']['name'] == "Ubuntu" and $facts['os']['release']['full'] == "16.04" {
    # Make the os dns resolver more reliable
    # (faster timeouts, round robin
    file { '/etc/resolvconf/resolv.conf.d/base':
      ensure  => file,
      content => "# created by puppet, see man resolv.conf
options timeout:1 attempts:1 rotate
        ",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
    service { 'resolvconf':
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      subscribe  => File['/etc/resolvconf/resolv.conf.d/base'],
    }
  } else {
    # using systemd-resolved for UDP racecondition NATed source-Port A vs AAAA Bug
    notice("configuring /etc/systemd/resolved.conf")
    file { '/etc/systemd/resolved.conf':
      ensure  => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      content => template("hosting_basesetup/resolved/resolved.erb"),
  }
    }
  }
}