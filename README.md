Overview
--------

This project implements a basic system setup for the following platforms:

* Ubuntu 16.04 LTS (tested by spectests)
* Debian Strech (tested by spectests)
* Centos 7 (uncomplete)

This setup can be used as a base for server systems.
The setup ist tested by using test-kitchen and serverspec tests.
(for Details, review the [Documentation of the test setup](README_Test_Environment.mf))

Things implemented with this setup
----------------------------------

* motd generation by template
* basic sysctl kernel settings
  * 10g networking
  * oops-behavior, swappiness, ...
  * custom systctl settings via hiera
* hardening of openssh server/client
  * no password login
  * ciphers
  * ...
* installation of mosh shell
* time setup
  * secure ntp setup
  * rngd, improvement of random number generator for virtual systems
* postfix mta
  * deliver mails to smarthost
  * map root mail
  * ...
* usermanagement via hiera
  * group creation
  * user creation
  * generation of sudo permisssions based on configurable templates
  * distribution of ssh keys
  * distribution of standard dotfiles
  * distribution of user specific dotfiles from a specifyable location
* installation of zabbix agent
  * add additional zabbix-agent-extenion packages
* package installtion via hiera
  * numerous useful packages
  * set vim as standard editor
* lvm management via hiera<BR>
  (review https://github.com/puppetlabs/puppetlabs-lvm)
* apt source management<BR>
  https://forge.puppet.com/puppetlabs/apt
* unattended configurable os updates<BR>
  https://forge.puppet.com/puppet/unattended_upgrades
* at/cron setup
* ulimits
  
Currently not implemented/TODOs
--------------------------------

by priority:

* Fix error messages on test execution
	kitchen verify default-ubuntu-1604-virtualbox-puppet5-hosting-basesetup 
	Ignoring executable-hooks-1.3.2 because its extensions are not built.  Try: gem pristine executable-hooks --version 1.3.2
	Ignoring gem-wrappers-1.3.2 because its extensions are not built.  Try: gem pristine gem-wrappers --version 1.3.2
	Error loading RubyGems plugin "/home/schoecmc/.rvm/gems/ruby-2.4.1@global/gems/executable-hooks-1.3.2/lib/rubygems_plugin.rb": cannot load such file -- executable-hooks/wrapper (LoadError)
	Error loading RubyGems plugin "/home/schoecmc/.rvm/gems/ruby-2.4.1@global/gems/gem-wrappers-1.3.2/lib/rubygems_plugin.rb": cannot load such file -- gem-wrappers (LoadError)
* reduce dprecation warnings of used modules
* use hiera data in module for distibution specific parameters
* use testinfra as testing framework
  https://testinfra.readthedocs.io/en/latest/
* Increase memory of vagrant/kitchen vms or reduce memory consumption (32bit vms) for complexer setups
* install and configure puppet final agent config<BR>
  (provide capability to switch environment)
* logshipping to syslog
* logstash/graylog support
* aide intrusion detection

Contribution
------------

 * file a bug on the github project: https://github.com/scoopex/puppet-hosting_basesetup/issues
 * fork the project and improve the template
 * create a pull/merge request

