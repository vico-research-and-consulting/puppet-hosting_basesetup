define hosting_basesetup::usermanagement::user (
  String $username                             = $title,
  String $group_primary,
  Integer $uid,
  String $fullname,
  String $homedir_base                         = "/home",
  Array[String] $groups                        = [],
  Array[String] $ssh_keys                      = [],
  Array[String] $restriction_tags              = [],
  Boolean $restriction_tags_enforce            = false,
  Enum['present', 'absent', 'defined'] $ensure = 'present',
  String $passwordhash                         = '*',
  String $mail                                 = 'Mailadress not specified',
  String $shell                                = '/bin/bash',
  String $dotfile_sourcedir                    = $::hosting_basesetup::usermanagement::user_dotfile_default_sourcedir,
) {


  if ($restriction_tags_enforce or (length($restriction_tags) > 0 and $::hosting_basesetup::usermanagement::restriction_tag != ''))
  {
    if $::hosting_basesetup::usermanagement::restriction_tag in $restriction_tags {
      $ensure_final = $ensure
    } else {
      $ensure_final = 'absent'
    }
  } else {
    $ensure_final = $ensure
  }

  if $ensure_final == 'present' {
    user { $username:
      ensure     => 'present',
      uid        => $uid,
      gid        => $group_primary,
      groups     => $groups,
      shell      => '/bin/bash',
      managehome => true,
      home       => "${homedir_base}/${username}",
      require    => [Group[$group_primary], File_Line['min_uid']],
      password   => $passwordhash,
      comment    => "${username}, ${fullname}",
    } ->
    file { "${homedir_base}/${username}/.ssh":
      ensure => 'directory',
      owner  => $username,
      group  => $group_primary,
      mode   => '0700',
    } ->
    file { "${homedir_base}/${username}/.ssh/authorized_keys":
      ensure  => 'present',
      owner   => $username,
      group   => $group_primary,
      mode    => '0600',
      backup  => false,
      content => template("hosting_basesetup/authorized_keys.erb"),
    }

    if $dotfile_sourcedir != "no" {
      file { "${homedir_base}/${username}/":
        path    => "${homedir_base}/${username}/",
        ensure  => 'directory',
        owner   => $username,
        group   => $group_primary,
        source  => $dotfile_sourcedir,
        backup  => false,
        require => User[$username],
        recurse => remote,
      }
    }
    anchor { "hosting_basesetup_user_uid_${uid}": } # prevents duplicate allocation of uids
  }elsif ($ensure_final == 'defined') {
    notice("defined, but not present here")
    anchor { "hosting_basesetup_user_uid_${uid}": } # prevents duplicate allocation of uids
  }else {
    file { "${homedir_base}/${username}/.ssh/authorized_keys":
      ensure => 'absent',
    }
    -> user { $username:
      ensure => 'absent',
    }
  }

}
