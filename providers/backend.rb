# haproxy_backend resource provider
#
actions :create, :delete

attribute :name, :kind_of => String, :name_attribute => true

# override to specify your own template
attribute :template, :kind_of => String, :default => "backend.cfg.erb"
attribute :cookbook, :kind_of => String, :default => "haproxy"


## actual configs
attribute :mode, :kind_of => String, :default => "http", :equal_to => %w(http tcp)

# ssl
attribute :ssl, :kind_of => [ TrueClass, FalseClass ], :default => false
# name of the certificate. Defaults to name.pem (in the provider)
attribute :ssl_cert, :kind_of => [ String ], :default => nil


## FIXME  log -> global policy
# FIXME httplog?
#attribute :option, :kind_of => String, :default => 'httplog'
attribute :options, :kind_of => Array, :default => []

# Client timeout, in seconds
attribute :timeout_client, :kind_of => [Integer], :default => 25
attribute :timeout_server, :kind_of => [Integer], :default => 25
# FIXME: other kind of timeout!

# FIXME: default value ok?
attribute :maxconn, :kind_of => [Integer], :default => 10000


# Actual config
attribute :config, :kind_of => String, :default => ""


# Pick our servers 
attribute :default_server, :kind_of => String, :default => nil

# do as search or...
attribute :servers_search, :kind_of => String, :default => nil
# specify the list of servers
attribute :servers_name, :kind_of => Array , :default => nil
# or specify a llist of server configs
attribute :servers_config, :kind_of => Array , :default => nil

# use with server search or servers_name
attribute :server_default_maxconn, :kind_of => Integer, :default => 1000
attribute :server_default_weight, :kind_of => Integer, :default => 10 

#backend bk_waf
#  balance roundrobin
#  mode http
#  log global
#  option httplog
#  option forwardfor header X-Client-IP
#  option httpchk HEAD /waf_health_check HTTP/1.0
# 
#  # If the source IP generated 10 or more http request over the defined period,
#  # flag the IP as abuser on the frontend
#  acl abuse sc1_http_err_rate(ft_waf) ge 10
#  acl flag_abuser sc1_inc_gpc0(ft_waf)
#  tcp-request content reject if abuse flag_abuser
# 
#  # Specific WAF checking: a DENY means everything is OK
#  http-check expect status 403
#  timeout server 25s
#  default-server inter 3s rise 2 fall 3
#  server waf1 192.168.10.15:81 maxconn 100 weight 10 check
#  server waf2 192.168.10.16:81 maxconn 100 weight 10 check
#
