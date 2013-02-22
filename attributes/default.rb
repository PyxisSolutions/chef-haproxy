# 1.5.17 aka 1.5-dev17 - latest ssl enabled version
default['haproxy']['version'] = "1.5.17"
default['haproxy']['enable_ssl'] = true

default['haproxy']['user'] = "haproxy"
default['haproxy']['group'] = "haproxy"

default['haproxy']['log_address']  = "127.0.0.1"
default['haproxy']['log_facility'] = "local2"

# config
default['haproxy']['conf_dir'] = "/etc/haproxy"
default['haproxy']['config'] = "#{node['haproxy']['conf_dir']}/haproxy.cfg"
default['haproxy']['tmp_config_dir'] = "#{node['haproxy']['conf_dir']}/conf.d"
default['haproxy']['pid_file'] = "/var/run/haproxy.pid"

# admin
default['haproxy']['admin']['enable'] = true
default['haproxy']['admin']['address_bind'] = "127.0.0.1"
default['haproxy']['admin']['port'] = 1936
default['haproxy']['admin']['user'] = 'haproxy'
default['haproxy']['admin']['password'] = 'givemedata'

# defaults
#default['haproxy']['defaults']['max_connections'] = 4096

default['haproxy']['defaults']['options'] = [ "dontlognull", "redispatch"]

default['haproxy']['defaults']['timeouts']['connect'] = "5s"
default['haproxy']['defaults']['timeouts']['client'] = "50s"
default['haproxy']['defaults']['timeouts']['server'] = "50s"
default['haproxy']['defaults']['timeouts']['check'] = "10s"
default['haproxy']['defaults']['timeouts']['http-request'] = "10s"
default['haproxy']['defaults']['timeouts']['http-keep-alive'] = "10s"

# global
default['haproxy']['defaults']['max_connections'] = 4096

