name "apache2_mod_php"
description "Configure php5.3 and apache2 with mod_php."
run_list(
  "recipe[php]",
  "recipe[apache2]",
  "recipe[apache2::mod_expires]",
  "recipe[apache2::mod_php5]",
  "recipe[apache2::mod_rewrite]"
)
default_attributes(
  :apache => {
    :listen_ports => [ "80", "443" ],
    :keepaliverequests => 10,
    :prefork => {
      :startservers => 2,
      :minspareservers => 1,
      :maxspareservers => 3,
      :serverlimit => 4,
      :maxclients => 4,
      :maxrequestsperchild => 1000
    },
    :worker => {
      :startservers => 2,
      :maxclients => 128,
      :minsparethreads => 16,
      :maxsparethreads => 128,
      :threadsperchild => 16,
      :maxrequestsperchild => 0
    }
  },
  :php5 => {
    :max_execution_time => "60",
    :memory_limit => "256M"
  }
)
