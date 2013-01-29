current_dir = File.dirname(__FILE__)

file_cache_path "/tmp/chef-solo"
data_bag_path "#{current_dir}/data_bags"
cookbook_path [ "#{current_dir}/cookbooks", "#{current_dir}/cookbooks-override", "#{current_dir}/cookbooks-projects" ]
role_path "#{current_dir}/roles"
