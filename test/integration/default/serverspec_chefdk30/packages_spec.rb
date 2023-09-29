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
describe package('curl') do
  it { should be_installed }
end
describe package('ncdu') do
  it { should be_installed }
end



#----------------------------------------------------------------------
# testing basic function
#----------------------------------------------------------------------

describe command('editor --version') do
  its(:stdout) { should match(/VIM - Vi IMproved/) }
end

#----------------------------------------------------------------------

