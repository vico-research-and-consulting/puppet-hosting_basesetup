class hosting_basesetup::packages () {
  case $::operatingsystem {
    'ubuntu', 'debian': {
      $packages = [
        'apt-transport-https',
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
        'strace',
        'sysfsutils']
      ensure_packages($packages)

      exec { 'update-alternatives --set editor /usr/bin/vim.basic':
        path    => '/bin:/sbin:/usr/bin:/usr/sbin',
        unless  => 'test /etc/alternatives/editor -ef /usr/bin/vim.basic',
        require => Package['vim'],
      }
    }
    'Centos': {
      $packages = [
        'curl',
        'wget',
        #'htop',
        #'iftop',
        'iptraf-ng',
        #'pv',
        'lsscsi',
        #'ncdu',
        #'scsitools',
        'sysstat',
        'xfsdump',
        'xfsprogs',
        'zip',
        'git-all',
        #'tig',
        'vim-enhanced',
        'finger',
        #'mailutils',
        'traceroute',
        'net-tools',
        'lvm2',
        'strace',
        'sysfsutils']
      ensure_packages($packages)
    }
    default: {
      fail("unsupported os: ${::operatingsystem}")
    }
  }
}

