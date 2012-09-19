current_dir = File.dirname(__FILE__)

cache_type 'BasicFile'
cache_options(:path => "#{ENV['HOME']}/.chef/checksums")
cookbook_path ["#{current_dir}/../cookbooks-projects", "#{current_dir}/../cookbooks-override", "#{current_dir}/../cookbooks"]
