class hosting_basesetup::packages () {
  case $::operatingsystem {
    'ubuntu' : {
      $packages = [
        'bash-completion',
        'curl',
        'wget',
        'htop',
        'iftop',
        'iptraf-ng',
        'pv',
        'lsscsi',
        'dialog',
        'ncdu',
        'scsitools',
        'sysstat',
        'xfsdump',
        'xfsprogs',
        'zip',
        'git',
        'tig',
        'vim',
        'finger',
        'mailutils',
        'traceroute',
        'net-tools',
        'lvm2',
        'sysfsutils']
      ensure_packages($packages)

      exec { 'update-alternatives --set editor /usr/bin/vim.basic':
        path    => '/bin:/sbin:/usr/bin:/usr/sbin',
        unless  => 'test /etc/alternatives/editor -ef /usr/bin/vim.basic',
        require => Package['vim'],
      }
    }
    default  : {
      fail("unsupported os: ${::osfamily}/${::operatingsystem}/${::operatingsystemrelease}")
    }
  }
}

