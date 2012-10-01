name "drupal"
description "Install requirements to run Drupal application (not includding HTTP server and PHP, which should be provided in different ways)."
run_list([
  "recipe[php::module_curl]",
  "recipe[php::module_gd]",
  "recipe[php::module_apc]",
  "recipe[drush::utils]",
  "recipe[drush::make]",
  "recipe[php::write_inis]",
])
default_attributes({
  :drush => {
    :version => "5.7.0",
  }
})
