%w{
  apache2
  cgi
}.each do |dir|
  link "/etc/php5/#{dir}/php.ini" do
    to "#{node['php']['conf_dir']}/php.ini"
    only_if "test -d /etc/php5/#{dir}/php.ini"
    notifies :restart, "service[apache2]"
  end
end
