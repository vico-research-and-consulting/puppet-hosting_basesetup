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


describe command('ls -ld /nfs') do
   its(:stdout) { should match(/^drwxr-xr-x 2 root root 4096 Jul 17 14:57 \/nfs$) }
end

#----------------------------------------------------------------------

