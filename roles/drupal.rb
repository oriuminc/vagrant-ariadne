name "drupal"
description "Install requirements to run Drupal application (not includding HTTP server and PHP, which should be provided in different ways)."
run_list(
  "recipe[php::module_curl]",
  "recipe[php::module_gd]",
  "recipe[php::module_mysql]",
  "recipe[php::module_memcache]"
)
