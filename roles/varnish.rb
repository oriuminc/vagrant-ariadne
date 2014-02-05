name "varnish_frontend"
description "Install Varnish HTTP Cache infront of a specified server and port."
run_list(
  "recipe[varnish::apt_repo]",
  "recipe[varnish]"
)
default_attributes(
  :varnish => {
    :version => "2.1",
    :vcl_conf => "drupal.vcl",
    :vcl_cookbook => "ariadne",
    :listen_port => "80",
    :backend_host => "127.0.0.1",
    :backend_port => "8080",
  }
)
# Must be override or array just gets merged (and port 80 included)
override_attributes(
  :apache => {
    :listen_ports => [
      "8080",
      "443"
    ]
  }
)
