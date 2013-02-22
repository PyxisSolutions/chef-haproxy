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
attribute :ssl_databag, :kind_of => String , :default => "ssl" 
attribute :ssl_databag_item, :kind_of => String , :default => nil
attribute :ssl_databag_secret, :kind_of => String, :default => "encrypted_data_bag_secret"


## FIXME  log -> global policy
attribute :log, :kind_of => String, :default => 'global'

# FIXME httplog? vs tcp...
attribute :options, :kind_of => Array, :default => []

# Client timeout, in milliseconds
attribute :timeout_client, :kind_of => [Integer], :default => 2500
# FIXME: other kind of timeout!

# FIXME: default value ok?
attribute :maxconn, :kind_of => [Integer], :default => 10000


# Actual config
attribute :raw_config, :kind_of => String, :default => ""

# If non-nil, will be added to the config after the config block
attribute :default_backend, :kind_of => String, :default => nil

