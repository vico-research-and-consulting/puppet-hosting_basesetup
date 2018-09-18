class hosting_basesetup::kernel::parameters (
  String $options = $::hosting_basesetup::kernel::grub_options
) {

  # file_line { "grub-noquiet":
  #   path   => "/etc/default/grub",
  #   line   => 'GRUB_CMDLINE_LINUX_DEFAULT="\1 \2"',
  #   match  => '^GRUB_CMDLINE_LINUX_DEFAULT="(.*)quiet(.*)"$',
  #   ensure => absent,
  #   notify => Exec['refresh-grub'],
  # }
  #
  # file_line { "grub-nosplash":
  #   path   => "/etc/default/grub",
  #   line   => 'GRUB_CMDLINE_LINUX_DEFAULT="\1 \2"',
  #   match  => '^GRUB_CMDLINE_LINUX_DEFAULT="(.*)splash(.*)"$',
  #   ensure => absent,
  #   notify => Exec['refresh-grub'],
  # }
  # file_line { "grub-options":
  #   path   => "/etc/default/grub",
  #   line   => "GRUB_CMDLINE_LINUX_DEFAULT=\"\1 ${options}\"",
  #   match  => '^GRUB_CMDLINE_LINUX_DEFAULT="(.*)"$',
  #   notify => Exec['refresh-grub'],
  # }

  exec { 'remove-spash_and_quiet':
    command => "/bin/sed -i -e '/^GRUB_CMDLINE_LINUX\\(_DEFAULT\\)\\?=/{~s,\\(quiet\|splash\\)[ ]*,,g;~s,\\\"$, ${options}\\\",}' /etc/default/grub",
    onlyif  => '/bin/grep -q "\(quiet\|splash\)" /etc/default/grub',
    notify => Exec['refresh-grub'],
    user => "root",
    group => "root",
    path => '/usr/bin:/usr/sbin:/bin:/sbin',
  }

  case $::operatingsystem {
    'ubuntu', 'debian': {
      exec { "update-grub":
        alias       => "refresh-grub",
        user        => 'root',
        path        => '/usr/bin:/usr/sbin:/bin:/sbin',
        refreshonly => true,
      }
    }
    'Centos': {
      exec { "grub2-mkconfig -o /boot/grub2/grub.cfg":
        alias       => "refresh-grub",
        user        => 'root',
        path        => '/usr/bin:/usr/sbin:/bin:/sbin',
        refreshonly => true,
      }
    }
    default: {
      fail("unsupported os: ${::operatingsystem}")
    }
  }

  ############################################################################################################


}
