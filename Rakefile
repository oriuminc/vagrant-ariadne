require 'vagrant'

desc "Restarts the network service inside the VM.

This often needs to be run when you've changes wifi hotspots or have been
disconnected temporily. If the VM is taking a long to time provision, or timing
out, run this task."
task :fix_network do
  env = Vagrant::Environment.new
  env.vms.each do |id, vm|
    raise Vagrant::Errors::VMNotCreatedError if !vm.created?
    raise Vagrant::Errors::VMNotRunningError if vm.state != :running

    vm.channel.sudo("/etc/init.d/networking restart")
  end
end

desc "Bring Ariadne back to a pristine state, good-as-new.

This will:
* uninstall the DNS resolver and tmp vagrant-dns files
* destroy the VM
* delete cookbooks, gems, apt packages, project-specific data & tmp dns files
* remove ariadne ruby version and source"
task :fresh_start do
  system "rvmsudo bundle exec vagrant dns --uninstall"
  system "bundle exec vagrant destroy --force"
  system "rm -r ~/.vagrant.d/tmp/dns"
  system "rm -rf tmp/ cookbooks/ .bundle/"
  system "chmod -R u+w data/html/; rm -rf data/html/*"
  system "rvm remove 1.9.3-p194-ariadne"
end

desc "Import an Ariadne project from GitHub.

Currently, the `repo` argument is expected to be in the format
`username/repo`."
task :init_project, [:repo] do |t, args|
  username = args.repo.split("/")[0]
  repo = args.repo.split("/")[1]
  projectname = repo.sub(/^ariadne-/, '')
  system "git clone git@github.com:#{username}/#{repo}.git ariadne-#{projectname}"
end

desc "Clear DNS cache and restart resolver.

Sometimes the Mac's DNS resolver controlled by vagrant-dns can go wonky. This
will clear the Mac's DNS cache and restart the vagrant-dns resolver."
task :refresh_dns do
  system "scacheutil -flushcache"
  system "vagrant dns --restart"
end

desc "Transfers your user-specific .gitconfig to the VM.

While this will transfer lots of personal settings into the VM, it perhaps most
importantly ensures that your commits are tied to your name and email. This
will ensure that your commits are properly linked your GitHub account."
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
