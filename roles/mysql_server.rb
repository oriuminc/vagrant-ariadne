name "mysql_server"
description "Configure host to run MySQL server."
run_list(
  "recipe[percona::server]"
)
default_attributes(
  :mysql => {
    :bind_address => "127.0.0.1",
    :tunable => {
      :key_buffer => "384M",
      :table_cache => "4096",
    },
  },
  :percona => {
    :version => "5.5",
  }
)
