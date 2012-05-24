require 'vagrant'

desc "Transfers your id_rsa SSH keypair to the VM."
task :send_keys do
  env = Vagrant::Environment.new
  env.vms.each do |id, vm|
    raise Vagrant::Errors::VMNotCreatedError if !vm.created?
    raise Vagrant::Errors::VMNotRunningError if vm.state != :running

    ssh_info = vm.ssh.info
    ssh_host = ssh_info[:host]
    ssh_port = ssh_info[:port]
    ssh_user = ssh_info[:username]
    private_key_path = ssh_info[:private_key_path]

    key_name = "id_rsa"
    system "scp -i #{private_key_path} -P #{ssh_port} ~/.ssh/#{key_name} ~/.ssh/#{key_name}.pub #{ssh_user}@#{ssh_host}:~/.ssh/"
    raise "Could not find id_rsa keypair in ~/.ssh" if $? != 0
    puts "SSH keys sent to #{vm.name} VM!"
  end
end

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
