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
describe package('postfix') do
  it { should be_installed }
end

describe service('postfix') do
  it { should be_enabled }
end

describe service('postfix') do
  it { should be_running }
end


#----------------------------------------------------------------------
# testing basic function
#----------------------------------------------------------------------

describe command('cat /etc/fstab|mail -s "TEST" devnull@256bit.org') do
   its(:stderr) { should_not match(/..*/) }
   its(:exit_status) { should eq 0 }
end

#----------------------------------------------------------------------

