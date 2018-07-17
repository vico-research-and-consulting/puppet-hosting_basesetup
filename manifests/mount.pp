define hosting_basesetup::mount (
  String $ensure,
  String $owner = "root",
  String $group = "root",
  String $mode = "0755",
  Boolean $atboot,
  String $device,
  String $fstype,
  String $options,
  Integer $dump = 0,
  Integer $pass = 1,
) {

  if ($fstype == "nfs"){
    # TODO: Implement IDMAP Settings
    ensure_packages(["nfs-common"], { ensure => 'present', before => Mount[$name]})
  }

  file { $name:
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }
  mount { $name:
    ensure  => $ensure,
    atboot  => $atboot,
    device  => $device,
    fstype  => $fstype,
    options => $options,
    dump    => $dump,
    pass    => $pass,
    require => File[$name],
  }
}
