source "http://rubygems.org"

gem "chef"
# Lock, as later version have issues on win32
gem "ffi", "<= 1.0.9"
gem "librarian"
gem "rake"
gem "rubygems-bundler"
gem "vagrant", "> 1"
gem "vagrant-dns",
  # Only *nix systems, as eventmachine dep has issues on win32
  :platform => "ruby"
#gem "vagrant-putty",
#  :platform => "mswin",
#  :git => "http://github.com/npeters/vagrant-putty.git",
#  :ref => "master"
gem "vagrant-vbguest"

group :development do
end
