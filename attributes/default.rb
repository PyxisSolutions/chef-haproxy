# 1.5.17 aka 1.5-dev17 - latest ssl enabled version
default['haproxy']['version'] = "1.5.17"
default['haproxy']['enable_ssl'] = true

default['haproxy']['user'] = "haproxy"
default['haproxy']['group'] = "haproxy"
default['haproxy']['config'] = "/etc/haproxy/haproxy.cfg"
default['haproxy']['tmp_config_dir'] = "/etc/haproxy/conf.d"
default['haproxy']['pid_file'] = "/var/run/haproxy.pid"


default['haproxy']['admin']['enable'] = true
default['haproxy']['admin']['address_bind'] = "127.0.0.1"
default['haproxy']['admin']['port'] = 1936


# defaults
default['haproxy']['defaults']['options'] = ["httplog", "dontlognull", "redispatch"]

default['haproxy']['defaults']['timeouts']['connect'] = "5s"
default['haproxy']['defaults']['timeouts']['client'] = "50s"
default['haproxy']['defaults']['timeouts']['server'] = "50s"

# global
default['haproxy']['global']['max_connections'] = 4096
default['haproxy']['x_forwarded_for'] = false

#??
#default['haproxy']['balance_algorithm'] = "roundrobin"
#default['haproxy']['listen_address'] = "0.0.0.0"
#default['haproxy']['incoming_port'] = 80
#default['haproxy']['httpchk'] = nil
#
