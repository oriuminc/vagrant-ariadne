name "acquia"
description "Install requirements to run Drupal application (not includding HTTP server and PHP, which should be provided in different ways)."
run_list([
  "role[apache2_mod_php]",
  "role[memcache]",
  "role[mysql]",
  "role[varnish]",
  "role[drupal]",
])
default_attributes({
})
