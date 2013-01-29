name "acquia"
description "Install requirements to run Drupal application (not includding HTTP server and PHP, which should be provided in different ways)."
run_list([
  "role[mysql]",
  "role[apache2_php_cgi]",
  "role[memcache]",
  "role[varnish]",
  "role[drupal]",
])
default_attributes({
})
