require 'vagrant'

desc "Restarts the network service inside the VM."
task :fix_network do
  env = Vagrant::Environment.new
  env.vms.each do |id, vm|
    raise Vagrant::Errors::VMNotCreatedError if !vm.created?
    raise Vagrant::Errors::VMNotRunningError if vm.state != :running

    vm.channel.sudo("/etc/init.d/networking restart")
  end
end

desc "Get back to square one (destroy, dns, cookbooks, gems, VM's, apt cache, data, etc.)"
task :fresh_start do
  system "rvmsudo bundle exec vagrant dns --uninstall"
  system "bundle exec vagrant destroy --force"
  system "rm -rf tmp/ cookbooks/ .bundle/"
  system "chmod -R u+x data/html/; rm -rf data/html/*"
end
