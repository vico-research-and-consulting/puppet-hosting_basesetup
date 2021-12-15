Overview
--------

This template utilizes [Test Kitchen](http://kitchen.ci/) to test puppetcode.
You can use this template to write new puppet modules or to enhance existing modules.

It provides the following aspects:

  * puppet template with demo code which installs a lighthttpd
  * convenient development environment 
    * download and create a ubuntu and debian image in a virtualbox environment
    * download and create a ubuntu docker image 
    * basic installation of puppet 4/5 client
    * automatic installation of puppet modules specified in the "Puppetfile" using librarian
  * check the setup using serverspec tests executed in the environment

Why do i need that?

  * provide convenient test setups for system development
  * reduce the need to develop on production or shared testsystems<BR>
    (sometimes you still need this, i.e. if you need special hardware to test your implementation)
  * test multiple variants of a setup on different operating systems<BR>
    (Ubuntu 14.04, 16.04, OpenSuse, ...)
  * prevent time consuming and git history polluting edit locally, commit/push, puppet execution roundtrips
  * automatically install needed puppet modules
  * easily test defined combinations of modules/roles
  * integrate automated tests to your ci-pipeline (i.e. jenkins)
  * reduce resource overhead by simply throwing away outdated setups
  * Execute tests remotely end very time efficient on AWS/EC2, Openstack, Vagrant, ...

Resources
---------

 * this project is based/located on https://github.com/scoopex/puppet-hosting_basesetup
 * test kitchen: 
   * http://kitchen.ci/
   * https://docs.chef.io/kitchen.html
   * https://github.com/test-kitchen/test-kitchen
   * https://docs.chef.io/config_yml_kitchen.html
   * https://docs.chef.io/plugin_kitchen_vagrant.html
   * https://github.com/neillturner/kitchen-puppet/blob/master/provisioner_options.md
 * serverspec tests
  * resources : http://serverspec.org/resource_types.html
 * puppet modules: https://forge.puppet.com/
 * puppet FAQ: https://ask.puppet.com/question/32373/is-there-a-document-on-how-to-setup-test-kitchen-with-puppet/
 * misc
  * https://de.slideshare.net/MartinEtmajer/testdriven-infrastructure-with-puppet-test-kitchen-serverspec-and-rspec
  * http://ehaselwanter.com/en/blog/2014/05/08/using-test-kitchen-with-puppet/
  * https://apache.googlesource.com/infrastructure-puppet-kitchen/
 * Librarian: http://librarian-puppet.com/

How to start:
------------------------------------

  * Install virtualbox: https://www.virtualbox.org/wiki/Linux_Downloads
  * Installation of vagrant
   * see: https://www.vagrantup.com/downloads.html
   * Download und Installation
     ```
     cd /tmp
     wget https://releases.hashicorp.com/vagrant/2.0.1/vagrant_2.0.1_x86_64.deb
     sudo dpkg -i vagrant_*_x86_64.deb
     ```
  * Install docker
   * see: https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-docker-ce
   * Download and installation (using "zesty" releas on "artful" because docker ubuntu repos not seem to be complete now)
     ```
     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	   sudo add-apt-repository \
		   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		   zesty \
		   stable"
     apt-get install docker-ce
     ```
  * Clone the repo
    ```
    git clone https://github.com/scoopex/puppet-hosting_basesetup.git
    cd puppet-hosting_basesetup
    ```
  * Installation of RVM
     * Follow the offical installation procedure at https://rvm.io/, i.e.:
       ```
       gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
       \curl -sSL https://get.rvm.io | bash -s stable
       # source this or add this to your .bashrc
       source ~/.rvm/scripts/rvm
       exec bash
       # asks for root password and installs packages like libyaml-dev, libsqlite3-dev, libgdbm-dev, libncurses5-dev, bison, libreadline6-dev
       rvm install "ruby-2.4.1"
       ```
     * Configuration of RVM<br>
       After the rvm installtion a configuration file (~/.rvmrc) should be created with the following content:
       ```
       echo "rvm_autoinstall_bundler_flag=1" >> ~/.rvmrc
       apt install ruby-dev libgmp-dev
       gem install bundler
       # Now the automatic invocation of bundler should install all the missing gems
       cd ..; cd puppet-hosting_basesetup
       ```
       This allows the convinient automatic installation of bundler.

     * Install Ruby, work with control repositories
       There are numerous possibilities to work with RVM - we are unsing the Gemfile procedure.
       see: Gemfile
       ```
       source 'https://rubygems.org'

       #ruby=2.0.0-p645
       #ruby-gemset=puppet-testing

       (...)
       ```
       The entries with the leading hashes (#) are not disabled entries. You have to install the configured ruby release in a manual procedure.
       You will get a notification "Required ruby-2.4.1 is not installed." if this step is missing.

       "test-kitchen": Serverspec Test mit Vagrant/Virtualbox/Docker

Cheat Sheet
-----------

```
Command                              Description
------------------------------------------------------------------------
kitchen list                         View all test suites
kitchen create                       Create the target system (Vagrant)
kitchen create <suite>
kitchen converge <suite>             Execute puppet (Puppet)
kitchen login <suite>                SSH Login
kitchen verify <suite>               Execute test suites (servespec)
kitchen test <suite>                 Create, test and destroy system
kitchen destroy                      Destroy all test systems
kitchen destroy <suite>              Destroy a certain test system

kitchen verify -l debug              Get enhanced debug information

librarian-puppet install --verbose   Debug librarian problems
librarian-puppet show --detailed     Show librarian dependencies
------------------------------------------------------------------------
```

Instance selection/handling:

* Use "kitchen list" to identify instances
* Add the full name of the instances to a certain command
   * Kitches selects instances by regex matches, so think about naming schemes
   * If you do not specify a regex ".*" is automatically assumed
* Kitchen automatically create all permutations of suites and platforms, see .kitchen.yml


Develop and test puppet code
-------------------------------

 * Change to the directory
   ```
   cd puppet-hosting_basesetup
   ```
 * Reset the environment<br>
   (if you want to revert everything)
   ```
   kitchen destroy
   rm -rf Gemfile.lock Puppetfile.lock .kitchen .librarian/ .tmp/
   ```
 * Add Puppet modules and edit sourcecode
   ```
   vim Puppetfile 
   vim manifests/* 
   vim test/integration/default/serverspec/*
   ```
 * Deploy a test system and login to the system for debugging purposes
   ```
   kitchen list
   kitchen create <instance>
   kitchen login <instance>
      sudo bash
   ```
 * Execute puppet withe the current code
   ```
   kitchen converge <instance>
   ```
 * Execute serverspec tests
   ```
   kitchen verify <instance>
   ```
 * Destroy environment
   ```
   kitchen destroy <instance>
   ```


Contribution
------------

 * file a bug on the github project: https://github.com/scoopex/puppet-hosting_basesetup/issues
 * fork the project and improve the template
 * create a pull/merge request

