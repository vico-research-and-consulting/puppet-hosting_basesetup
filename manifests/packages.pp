class hosting_basesetup::packages () {
  if ($facts['os']['family'] == 'Debian' and $facts['os']['release']['major'] == "8") {
    apt::source { 'jessie_backports':
      comment  => 'Jessie Backports',
      location => 'http://ftp.debian.org/debian',
      release  => 'jessie-backports',
      repos    => 'main',
      # key      => {
      #   'id'     => 'A1BD8E9D78F7FE5C3E65D8AF8B48AD6246925553',
      #   'server' => 'subkeys.pgp.net',
      # },
      include  => {
        # 'src' => true,
        'deb' => true,
      },
    }
  }
  case $::operatingsystem {
    'ubuntu', 'debian' : {
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
        'sysfsutils']
      ensure_packages($packages)

      exec { 'update-alternatives --set editor /usr/bin/vim.basic':
        path    => '/bin:/sbin:/usr/bin:/usr/sbin',
        unless  => 'test /etc/alternatives/editor -ef /usr/bin/vim.basic',
        require => Package['vim'],
      }
    }
    'Centos' : {
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
        'sysfsutils']
      ensure_packages($packages)
    }
    default  : {
      fail("unsupported os: ${::operatingsystem}")
    }
  }
}

