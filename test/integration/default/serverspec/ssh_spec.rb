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
describe package('mosh') do
  it { should be_installed }
end

describe service('ssh') do
  it { should be_enabled }
end

describe service('ssh') do
  it { should be_running }
end


#----------------------------------------------------------------------
# testing basic function
#----------------------------------------------------------------------

describe command('ssh -vvv -o StrictHostKeyChecking=no root@localhost') do
  its(:stderr) { should_not match(/Authentications that can continue: password/) }
  its(:stderr) { should match(/Authentications that can continue: publickey/) }
end

#----------------------------------------------------------------------

