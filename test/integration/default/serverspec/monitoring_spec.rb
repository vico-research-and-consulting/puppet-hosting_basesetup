#----------------------------------------------------------------------
# instantiating testing requirements
#----------------------------------------------------------------------

if (!ENV['w_ssh'].nil? && ENV['w_ssh'] = 'true')
  begin
    require 'spec_helper.rb'
  rescue LoadError
  end
else
  begin
    require 'spec_helper.rb'
    set :backend, :exec
  rescue LoadError
  end
end
#----------------------------------------------------------------------

#  http://serverspec.org/resource_types.html

#----------------------------------------------------------------------
# testing basic service
#----------------------------------------------------------------------
describe package('zabbix-agent') do
  it { should be_installed }
end

describe service('zabbix-agent') do
  it { should be_enabled }
end

describe service('zabbix-agent') do
  it { should be_running }
end


#----------------------------------------------------------------------
# testing basic function
#----------------------------------------------------------------------

describe command('zabbix_get -s 127.0.0.1 -k agent.ping') do
  its(:stdout) { should match(/^1$/) }
end

#----------------------------------------------------------------------

