link "/etc/php5/apache2/php.ini" do
  to "#{node['php']['conf_dir']}/php.ini"
  notifies :restart, "service[apache2]"
end
