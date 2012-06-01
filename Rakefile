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
  system "rvm remove 1.9.3-p194-ariadne"
end

desc "Import a ariadne project from GitHub. Example `rake init_project repo=username/demo`"
task :init_project do
  username = ENV['repo'].split("/")[0]
  repo = ENV['repo'].split("/")[1]
  projectname = repo.sub(/^ariadne-/, '')
  system "git clone git@github.com:#{username}/#{repo}.git ariadne-#{projectname}"
end

desc "Transfers your user-specific .gitconfig to the VM."
task :send_gitconfig do
  env = Vagrant::Environment.new
  env.vms.each do |id, vm|
    raise Vagrant::Errors::VMNotCreatedError if !vm.created?
    raise Vagrant::Errors::VMNotRunningError if vm.state != :running

    ssh_info = vm.ssh.info
    ssh_host = ssh_info[:host]
    ssh_port = ssh_info[:port]
    ssh_user = ssh_info[:username]
    private_key_path = ssh_info[:private_key_path]

    system "scp -i #{private_key_path} -P #{ssh_port} ~/.gitconfig #{ssh_user}@#{ssh_host}:~"
    raise "Could not find .gitconfig in home directory (~)." if $? != 0
    puts ".gitconfig sent to #{vm.name} VM!"
  end
end
