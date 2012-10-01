name "memcache"
description "Role for memcache setup."
run_list(
  "recipe[memcached]",
  "recipe[php::module_memcache]",
  "recipe[php::module_memcached]",
  "recipe[php::write_inis]",
)
default_attributes(
)
