source "http://rubygems.org"

gem "capistrano"
gem "capistrano-drush-make"
gem "chef",
  :git => "https://github.com/opscode/chef.git",
  :ref => "ba4d58f4223"
gem "inifile"
gem "librarian"
gem "railsless-deploy"
gem "vagrant", # 1.0.2 with myplanetdigital/vagrant/hosts-patch
  :git => "https://github.com/myplanetdigital/vagrant.git",
  :ref => "hosts-patch"
gem "vagrant-vbguest"

group :development do
  # Hammer.vim plugin requirements
  gem "github-markup"
  gem "tilt"
  gem "coderay"
  # Testing
  gem "vagrant-test"
  gem "watir-webdriver"
  gem "aruba"
  gem "cuken"
end
