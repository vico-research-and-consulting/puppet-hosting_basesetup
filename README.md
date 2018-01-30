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
* hardening of spenssh server/client
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

* Increase memory of vagrant/kitchen vms, reduce memory consumption (32bit vms)
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

