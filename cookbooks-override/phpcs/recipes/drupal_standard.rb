include_recipe "phpcs"

git "#{Chef::Config[:file_cache_path]}/drupalcs" do
  repository "http://git.drupal.org/project/drupalcs.git"
  revision "7.x-1.x"
  reference node['phpcs']['drupalcs_git_ref']
  action :sync
end

bash "copy-drupal-standard" do
  user "root"
  code <<-EOH
    cp -Rf #{Chef::Config[:file_cache_path]}/drupalcs/Drupal $(pear config-get php_dir)/PHP/CodeSniffer/Standards/
  EOH
  not_if "test -d $(pear config-get php_dir)/PHP/CodeSniffer/Standards/Drupal"
end

file "/home/vagrant/.bash_profile" do
  owner "vagrant"
  group "vagrant"
  content "alias drupalcs='phpcs --standard=Drupal --extensions=php,module,inc,install,test,profile,theme'"
  action :create_if_missing
end
