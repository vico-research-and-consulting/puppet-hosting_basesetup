#!/usr/bin/env ruby
#^syntax detection

forge 'https://forgeapi.puppetlabs.com'

# do not forget to update the dependencies at metadata.json on updates here

mod 'puppetlabs-apt'
mod 'puppetlabs-stdlib', '>=4.24.0'
mod 'puppetlabs-ntp', '>=7.1.0'
mod 'puppet-postfix', '5.0.0'
mod 'puppetlabs-puppet_agent', '>=4.9.0'
mod 'puppetlabs-lvm', '>=1.0.0'

#mod 'puppet-unattended_upgrades', '>=3.2.0 <=3.2.1'
# can be removed when dependency is > 7.0.1 : https://github.com/voxpupuli/puppet-unattended_upgrades/
mod 'puppet-unattended_upgrades',
  :git => 'https://github.com/vico-research-and-consulting/puppet-unattended_upgrades.git'

mod 'ghoneycutt-ssh', '3.62.0'

#mod 'test_repo',
#  :git => 'git@foobar.de/foobar_foo.git'
#
# Für Testzwecke
#mod 'my_local_module',
#  :path => '/usr/puppet/base/module/my_local_module'
