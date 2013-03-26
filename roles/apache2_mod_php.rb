name "apache2_mod_php"
description "Configure php5.3 and apache2 with mod_php."
run_list(
  "recipe[php]",
  "recipe[apache2]",
  "recipe[apache2::mod_expires]",
  "recipe[apache2::mod_rewrite]",
  "recipe[apache2::mod_php5]",
  "recipe[php::common_php_ini]"
)
default_attributes(
  :php => {
    :directives => {
      :memory_limit => "160M"
    }
  }
)
