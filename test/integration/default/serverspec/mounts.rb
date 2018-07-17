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

describe command('cat /etc/fstab') do
   its(:stdout) { should match(/^10.23.22.89:/srv/nfs/datastax   /nfs    nfs     defaults        0       2$/) }
end

#----------------------------------------------------------------------

