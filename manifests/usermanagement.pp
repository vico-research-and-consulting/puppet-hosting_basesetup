# == Class: hosting_basesetup::usermanagement
#
class hosting_basesetup::usermanagement (
  Hash $users                    = {},
  Hash $groups                   = {},
  String $rootpwhash,
  Array[String] $ssh_keys_root   = [],
  String $restriction_tag        = '',
  String $root_dotfile_sourcedir = 'puppet:///modules/hosting_basesetup/dotfiles_default/',
  Integer $minimal_gid           = 12000,
  Integer $minimal_uid           = 12000,
)
  {

    # Drop all files which are not managed by puppet
    file { '/etc/sudoers.d/':
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      backup  => false,
      recurse => true,
      purge   => true,
    }
    
    group { "root":
      ensure => present,
      gid    => 0,
    }

    file_line { 'min_gid':
      ensure => present,
      path   => '/etc/login.defs',
      line   => "GID_MIN                 ${minimal_gid}",
      match  => '^GID_MIN.*',
    }

    file_line { 'min_uid':
      ensure => present,
      path   => '/etc/login.defs',
      line   => "UID_MIN                 ${minimal_uid}",
      match  => '^UID_MIN.*',
    }

    == == == =
      $ssh_keys_root_final = union(
      $ssh_keys_root,
      $ssh_keys_root_additional,
    )

    hosting_basesetup::usermanagement::group { "root": gid => 0, }
    >> >> >> > fc9058efcdb2d0d072306bcba05eb11dad4cf632
  hosting_basesetup::usermanagement::user { "root":
    group_primary     => 'root',
    groups            => ['root'],
    homedir_base      => '',
    ssh_keys          => $ssh_keys_root_final,
    uid               => 0,
    fullname          => 'root',
    passwordhash      => $rootpwhash,
    dotfile_sourcedir => $root_dotfile_sourcedir,
    restriction_tags  => [],
  }

    create_resources("hosting_basesetup::usermanagement::group", $groups)
    create_resources("hosting_basesetup::usermanagement::user", $users)
  }
