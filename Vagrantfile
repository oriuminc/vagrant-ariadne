# -*- mode: ruby -*-
# vi: set ft=ruby :

current_dir = File.dirname(__FILE__)

# Add our custom strings to the load path
I18n.load_path << File.expand_path("../config/locales/en.yml", __FILE__)

# Raise error if running 64-bit VM on 32-bit host system.
class AriadneError < Vagrant::Errors::VagrantError
  error_key "ariadne_arch_crosscheck"
end

# Method to test if string is integer
class String
  def is_i?
    !!(self =~ /^[-+]?[0-9]+$/)
  end
end

# Write ENV var to config file. 
def create_config_envvar(envvar, conf)
  unless ENV[envvar].nil?
    conf[envvar] = ENV[envvar]
    conf[envvar] = conf[envvar].to_i if conf[envvar].is_i?
  end
end

# Mash of box names and urls
baseboxes = YAML.load_file("#{current_dir}/config/baseboxes.yml")

# Import configs from YAML file.
conf = YAML.load_file "#{current_dir}/roles/config.yml"

config_envvars = %w{ basebox branch cpu_count memory project repo_url roles }
config_envvars.each do |envvar|
  create_config_envvar(envvar, conf)
end

File.open("#{current_dir}/roles/config.yml", 'w') { |f| YAML.dump(conf, f) }

Vagrant::Config.run do |config|
  config.vm.define "ariadne"

  config.vm.box = conf['basebox']
  config.vm.box_url = baseboxes[config.vm.box]

  config.vm.network :hostonly, "33.33.33.10"

  config.vm.customize ["modifyvm", :id, "--memory", conf['memory']]
  config.vm.customize ["modifyvm", :id, "--cpus", conf['cpu_count']]

  # Forward keys and ssh configs into VM
  # Caveats: https://github.com/mitchellh/vagrant/issues/105
  config.ssh.forward_agent = true

  # Use vagrant-dns plugin to configure DNS server
  config.dns.tld = "dev"
  config.dns.patterns = [ /^.*\.dev$/ ]

  # Only enable NFS shares on *nix systems (Windows doesn't need).
  # Ref: http://vagrantup.com/v1/docs/nfs.html
  nfs_flag = (RUBY_PLATFORM =~ /linux|darwin/)

  # Share directories for project data and various caches
  config.vm.share_folder "apt-cache", "/var/cache/apt/archives", "./tmp/apt/cache", :nfs => nfs_flag
  config.vm.share_folder "drush-cache", "/home/vagrant/.drush/cache", "./tmp/drush/cache", :nfs => nfs_flag
  config.vm.share_folder "html", "/mnt/www/html", "./data/html", :nfs => nfs_flag

  # Forward web and mysql ports
  config.vm.forward_port 80, 8080, :auto => true
  config.vm.forward_port 3306, 9306

  # Uncomment for testing, to speed up initial provisioning by preventing the
  # vbguest Vagrant plugin from upgrading the Virtualbox Guest Additions.
  #
  # config.vbguest.no_install = true

  # Update Chef in VM to specific version before running chef provisioner
  config.vm.provision :shell do |shell|
    shell.path = "config/upgrade_chef.sh"
    shell.args = target_version = "10.14.2"
  end

  config.vm.provision :chef_solo do |chef|
    chef.roles_path = "roles"
    chef.cookbooks_path = [ "cookbooks", "cookbooks-override", "cookbooks-projects" ]
    chef.add_role "ariadne"

    # Assume install profile if repo_url given in config,
    # and project cookbook if not.
    # TODO: Move logic into ariadne role?
    if conf['repo_url'].empty?
      chef.add_recipe "#{conf['project']}::default"
    else
      chef.add_recipe "ariadne::install_profile"
    end

    # Option so cookbooks can wipe files when set on command-line
    clean_flag = true unless ENV['clean'].nil?

    chef.json = {
      "mysql" => {
        "server_debian_password" => "root",
        "server_root_password"   => "root",
        "server_repl_password"   => "root",
        "allow_remote_root" => true,
        "bind_address" => "0.0.0.0",
      },
      # Send conf hash into VM.
      "ariadne" => conf.merge({
        # Merge in option to wipe files when set on CLI
        "clean" => clean_flag,
      })
    }
  end
end
