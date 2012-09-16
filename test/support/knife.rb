current_dir = File.dirname(__FILE__)
cache_options( :path => '/tmp/chef/cache/checksums' )
cookbook_path [ "#{current_dir}/../../cookbooks", "#{current_dir}/../../cookbooks-override" ]
