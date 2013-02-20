# haproxy_frontend resource definition
#
actions :create, :delete

attribute :name, :kind_of => String, :name_attribute => true

# override to specify your own template
attribute :template, :kind_of => String, :default => "frontend.cfg.erb"
attribute :cookbook, :kind_of => String, :default => "haproxy"


## actual configs
attribute :mode, :kind_of => String, :default => "http", :equal_to => %w(http tcp)

# where to bind
attribute :bind_address,  :default => "*"
attribute :bind_port,     :default => "80"

# ssl
attribute :ssl, :kind_of => [ TrueClass, FalseClass ], :default => false
# name of the certificate. Defaults to name.pem (in the provider)
attribute :ssl_cert, :kind_of => [ String ], :default => nil


## FIXME  log -> global policy
# FIXME httplog?
attribute :option, :kind_of => String, :default => 'httplog'

# Client timeout, in seconds
attribute :timeout_client, :kind_of => [Integer], :default => 25
# FIXME: other kind of timeout!

# FIXME: default value ok?
attribute :maxconn, :kind_of => [Integer], :default => 10000


# Actual config
attribute :config, :kind_of => String, :default => ""

# If non-nil, will be added to the config after the config block
attribute :backend_default, :kind_of => String, :default => nil


## public frontend where users get connected to
#frontend ft_waf
#  bind 192.168.10.2:80 name http
#  mode http
#  log global
#  option httplog
#  timeout client 25s
#  maxconn 10000
# 
#  # DDOS protection
#  # Use General Purpose Couter (gpc) 0 in SC1 as a global abuse counter
#  # Monitors the number of request sent by an IP over a period of 10 seconds
#  stick-table type ip size 1m expire 1m store gpc0,http_req_rate(10s),http_err_rate(10s)
#  tcp-request connection track-sc1 src
#  tcp-request connection reject if { sc1_get_gpc0 gt 0 }
#  # Abuser means more than 100reqs/10s
#  acl abuse sc1_http_req_rate(ft_web) ge 100
#  acl flag_abuser sc1_inc_gpc0(ft_web)
#  tcp-request content reject if abuse flag_abuser
# 
#  acl static path_beg /static/ /dokuwiki/images/
#  acl no_waf nbsrv(bk_waf) eq 0
#  acl waf_max_capacity queue(bk_waf) ge 1
#  # bypass WAF farm if no WAF available
#  use_backend bk_web if no_waf
#  # bypass WAF farm if it reaches its capacity
#  use_backend bk_web if static waf_max_capacity
#  default_backend bk_waf
# 
#
