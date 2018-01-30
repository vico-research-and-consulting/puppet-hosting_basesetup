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
# testing basic function
#----------------------------------------------------------------------

describe command('sysctl -n kernel.panic_on_oops') do
   its(:stdout) { should match(/30/) }
end

describe command('sysctl -n net.core.netdev_max_backlog') do
   its(:stdout) { should match(/30000/) }
end

describe command('ulimit -n') do
   its(:stdout) { should match(/8192/) }
end

#----------------------------------------------------------------------

