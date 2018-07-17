# == Class: hosting_basesetup::mountpoints
#
class hosting_basesetup::mountpoints (
  Hash $mointpoints                       = {},
  Hash $mointpoints_override              = {},
)
  {
    $mountpoints = deep_merge($mountpoints, $mountpoints_override)

    $mountpoints.each | Hash $mountpoint | {
      mount { "${mountpoint['path']}":
        device => "${mountpoint['device']}",
        fstype => "${mountpoint['fstype']}",
        ensure => "${mountpoint['ensure']}",
        options => "${mountpoint['options']}",
        atboot => "${mountpoint['atboot']}",
      }
    }
  }
