include_recipe "phpcs"

# Only download if changed
# Adapted from http://wiki.opscode.com/display/chef/Resources#Resources-RemoteFile
f = remote_file "drupalcs" do
  path "#{Chef::Config[:file_cache_path]}/drupalcs-7.x-1.0-alpha1.tar.gz"
  source "http://ftp.drupal.org/files/projects/drupalcs-7.x-1.0-alpha1.tar.gz"
  action :nothing
end

http_request "HEAD #{f.source}" do
  message ""
  url f.source
  action :head
  if File.exists?(f.path)
    headers "If-Modified-Since" => File.mtime(f.path).httpdate
  end
  notifies :create, "remote_file[drupalcs]", :immediately
end
