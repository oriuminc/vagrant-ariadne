case platform
when "debian","ubuntu"
  set[:varnish][:dir]     = "/etc/varnish"
  set[:varnish][:default] = "/etc/default/varnish"
  set[:varnish][:secret_file] = "/etc/varnish/secret"
end

default[:varnish][:default_backend_host] = "localhost"
default[:varnish][:default_backend_port] = 8080

default[:varnish][:listen_address] = ""
default[:varnish][:listen_port] = 80

default[:varnish][:admin_listen_address] = "localhost"
default[:varnish][:admin_listen_port] = 6082

default[:varnish][:min_threads] = 1
default[:varnish][:max_threads] = 1000
default[:varnish][:thread_timeout] = 120

default[:varnish][:storage_file] = "/var/lib/varnish/$INSTANCE/varnish_storage.bin"
default[:varnish][:storage_size] = "1G"
default[:varnish][:storage] = "file,${VARNISH_STORAGE_FILE},${VARNISH_STORAGE_SIZE}"

default[:varnish][:ttl] = 120

default[:varnish][:daemon_opts] = "-a ${VARNISH_LISTEN_ADDRESS}:${VARNISH_LISTEN_PORT} \\
             -f ${VARNISH_VCL_CONF} \\
             -T ${VARNISH_ADMIN_LISTEN_ADDRESS}:${VARNISH_ADMIN_LISTEN_PORT} \\
             -t ${VARNISH_TTL} \\
             -w ${VARNISH_MIN_THREADS},${VARNISH_MAX_THREADS},${VARNISH_THREAD_TIMEOUT} \\
             -s ${VARNISH_STORAGE}"
