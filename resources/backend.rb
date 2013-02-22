# haproxy_backend resource definition

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
attribute :options, :kind_of => Array, :default => []

# Client timeout, in milliseconds
attribute :timeout_connect, :kind_of => [String, Integer], :default => "1s"
attribute :timeout_queue,  :kind_of => [String, Integer], :default => "25s"
attribute :timeout_server,  :kind_of => [String, Integer], :default => "60s"
# FIXME: other kind of timeout!

# FIXME: default value ok?
attribute :maxconn, :kind_of => [Integer], :default => 10000


# Actual config
attribute :raw_config, :kind_of => String, :default => nil 


# Pick our servers 
attribute :default_server, :kind_of => String, :default => nil
# Port to use on the destination servers
attribute :server_port, :kind_of => String, :default => "80"

# do as search or...
attribute :servers_search, :kind_of => String, :default => nil
# specify the list of servers
attribute :servers_name, :kind_of => Array , :default => nil
# or specify a llist of server configs
attribute :servers_config, :kind_of => Array , :default => nil

# use with server search or servers_name
attribute :server_maxconn, :kind_of => Integer, :default => 5000
attribute :server_weight, :kind_of => Integer, :default => 10 


