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
* package installtion via hiera
  * numerous useful packages
  * set vim as standard editor


Currently not implemented
-------------------------

* unattended configurable os updates
* ulimits
* apt source management
* lvm management via hiera
* logshipping to syslog
* logstash/graylog support
* at/cron setup
* aide intrusion detection

Contribution
------------

 * file a bug on the github project: https://github.com/scoopex/puppet-hosting_basesetup/issues
 * fork the project and improve the template
 * create a pull/merge request

