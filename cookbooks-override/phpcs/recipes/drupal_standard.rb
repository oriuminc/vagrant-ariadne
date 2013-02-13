include_recipe "phpcs"

git "#{Chef::Config[:file_cache_path]}/coder" do
  repository "http://git.drupal.org/project/coder.git"
  reference node['phpcs']['coder_git_ref']
  action :sync
end

bash "copy-drupal-standard" do
  user "root"
  code <<-EOH
    cp -Rf #{Chef::Config[:file_cache_path]}/coder/coder_sniffer/Drupal $(pear config-get php_dir)/PHP/CodeSniffer/Standards/
  EOH
  not_if "test -d $(pear config-get php_dir)/PHP/CodeSniffer/Standards/Drupal"
end

# `user` resource is interim solution so remote deploy works:
# https://github.com/myplanetdigital/vagrant-ariadne/pull/44
user "vagrant" do
  home "/home/vagrant"
  supports :manage_home => true
end

bash_profile "coder-alias" do
  user "vagrant"
end
