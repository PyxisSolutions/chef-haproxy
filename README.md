Description
===========

HAProxy installation and configuration, using LWRP for frontend and backend


Requirements
============

Assume we can install haproxy from packages.

SSL features needs HAProxy > 1.5.dev12 (tested with dev17)

Attributes
==========


default['haproxy']['version']    - Version to install. Default to 1.5.17 aka 1.5-dev17 - latest ssl enabled version
default['haproxy']['enable_ssl'] - Set to true if you want to force the installation of a package named haproxy-ssl

default['haproxy']['user'] = "haproxy"
default['haproxy']['group'] = "haproxy"

default['haproxy']['log_address']  - Syslog server address. Default "127.0.0.1"
default['haproxy']['log_facility'] - Syslog facility to use. default "local2"

# config
default['haproxy']['conf_dir'] - Config directory. Default to "/etc/haproxy"
default['haproxy']['config']   - main config file. Set automatically to haconfig.cfg

# admin
default['haproxy']['admin']['enable'] - Should we enable the stats web interface?
default['haproxy']['admin']['address_bind'] - Where to bind the stats interface 
default['haproxy']['admin']['port'] - stats interface, port 1936
default['haproxy']['admin']['user'] - stats interface, user
default['haproxy']['admin']['password'] - stats interface password

# Some default values

default['haproxy']['defaults']['options'] = [ "dontlognull", "redispatch"]
default['haproxy']['defaults']['timeouts']['connect'] = "5s"
default['haproxy']['defaults']['timeouts']['client'] = "50s"
default['haproxy']['defaults']['timeouts']['server'] = "50s"
default['haproxy']['defaults']['timeouts']['check'] = "10s"
default['haproxy']['defaults']['timeouts']['http-request'] = "10s"
default['haproxy']['defaults']['timeouts']['http-keep-alive'] = "10s"

# global
default['haproxy']['defaults']['max_connections'] = 4096



Usage
=====

Install HAProxy by adding it to your run list, or include the default recipe into a recipe
describing your load-balancing setup.

Use the haproxy_frontend and haproxy_backend LWRP to configure your load-balancing setup.

```ruby
include_recipe "haproxy"

haproxy_frontend "test" do
  action :create  
  mode 'http'
  default_backend "test"
  options %w( opt1 opt2)
  raw_config <<-EOF
  #  add your own config snippets
EOF
end

haproxy_backend "test" do
  action :create
  mode "http"
  options %w( opt1 opt2)
  server_port "8000"
  server_maxconn 12
  raw_config <<-EOF
  # more raw config
  EOF

  # set your list of server configuration directly... 
  servers_config [ "server a 1.2.3.4 check", "server b 1.2.3.5 check", "server c 1.2.3.6 backup"]
  # or use a search
  servers_search "roles:webserver"
end
```

Frontend LWRP
---------------

The following parameters are available for the frontend LWRP:

# templates
* template - override to specify your own template
* cookbook - the cookbook where we can find your template

# where to bind
* bind_address - default => "*"
* bind_port - default => "80"

# ssl
* ssl (true or false, default false) - enable SSL on this frontend
* ssl_cert - Name of the certificate. Defaults to frontend-name.pem. Certificates are stored in /etc/haproxy/ssl/
* ssl_databag - name of the databag that store your certificates (INCOMPLETE)
* ssl_databag_item - name of the item storing your certificate
* ssl_databag_secret - path of the encrypted data bag secret file to use

# others settings
* mode - Operating mode. tcp or http
* log - policy, default => 'global'
* options - array of Options to enable. None by default.
* timeout_client -  Client timeout, in milliseconds
* maxconn - max connection for this frontend. default => 10000
* raw_config - Raw config. Can be use to add arbitrary settings to your config. Use it for ACL rules, weird options, etc.
* default_backend - If non-nil, will be added to the config after the config block to set the default backend


Backend LWRP
------------

# templates

* template - override to specify your own template
* cookbook - the cookbook where we can find your template

# actual configs
* mode - Operating mode. tcp or http
* ssl (true or false, default false) - if true, will add the option ssl-hell-chk
* maxconn - max connection for this frontend. default => 10000
* raw_config - Raw config. Can be use to add arbitrary settings to your config. Use it for ACL rules, weird options, etc.

# timeouts
* timeout_connect - Timeout, connect
* timeout_queue - Timeout, queue
* timeout_server - Timeout, server

# servers setup
* server_port - Port to use on the destination servers
* default_server - If non-nil, will be added to the config after the config block to set the default server_
* server_maxconn - default max conn per server. default => 5000
* server_weight - default server weight. default => 10 

## setting the server list

Use one of the following method (or set only the default_server):

* servers_search - Add the server matching this search
* servers_name - Specify a list of name of server. WARNING: incomplete for now
* servers_config - Specify a list of server configs: array of string that contains the server configs

More complex configuration should use the servers_config method where you build your own lines of config with any settings that you need.


