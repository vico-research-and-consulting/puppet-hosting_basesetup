class hosting_basesetup::cron_at (
  Boolean $manage_user_scheduled_jobs = false,
  Array[String] $cron_users_allow = [ 'root' ],
  Array[String] $cron_users_deny = [],
  Array[String] $at_users_allow = [ 'root' ],
  Array[String] $at_users_deny = [],
)
{
  if $manage_user_scheduled_jobs {

    # If the file cron.allow exists, only users listed in it are allowed to use cron, and the cron.deny file is ignored.
    # If cron.allow does not exist, users listed in cron.deny are not allowed to use cron. 
    
    if ((length($cron_users_allow) == 0) and (length($cron_users_deny) > 0)) {
      # only allow the specified users
      file { '/etc/cron.allow': 
        ensure => absent
      }
      file { '/etc/cron.deny': 
        owner => 'root', 
        group => 'root', 
        mode => '0644', 
        content => template("hosting_basesetup/cron_at/cron_allow.erb"),
      }
    }elsif ((length($cron_users_allow) > 0) and (length($cron_users_deny) == 0)) {
      # deny the specified users
      file { '/etc/cron.deny': 
        ensure => absent
      }
      file { '/etc/cron.allow': 
        owner => 'root', 
        group => 'root', 
        mode => '0644', 
        content => template("hosting_basesetup/cron_at/cron_allow.erb"),
      }
    }else{
      fail('unlogic definition of hosting_basesetup::cron_at::cron_users_allow and hosting_basesetup::cron_at::cron_users_allow, check code/documentation')
    }

    if ((length($at_users_allow) == 0) and (length($at_users_deny) > 0)) {
      # only allow the specified users
      file { '/etc/at.allow': 
        ensure => absent
      }
      file { '/etc/at.deny': 
        owner => 'root', 
        group => 'root', 
        mode => '0644', 
        content => template("hosting_basesetup/cron_at/at_allow.erb"),
      }
    }elsif ((length($at_users_allow) > 0) and (length($at_users_deny) == 0)) {
      # deny the specified users
      file { '/etc/at.deny': 
        ensure => absent
      }
      file { '/etc/at.allow': 
        owner => 'root', 
        group => 'root', 
        mode => '0644', 
        content => template("hosting_basesetup/cron_at/at_allow.erb"),
      }
    }else{
      fail('unlogic definition of hosting_basesetup::cron_at::at_users_allow and hosting_basesetup::cron_at::at_users_allow, check code/documentation')
    }
  }
}
