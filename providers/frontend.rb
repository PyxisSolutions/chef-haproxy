# haproxy_frontend resource provider

action :create do

  # Dont forget to change action :delete if you change this ; we can't declare this at the top :(
  ssl_cert = new_resource.ssl_cert || "#{new_resource.name}.pem"
  ssl_dir = "#{node['haproxy']['conf_dir']}/ssl"


  if new_resource.ssl

    ssl_secret = Chef::EncryptedDataBagItem.load_secret(new_ressource.ssl_databag_secret)
    ssl_creds = Chef::EncryptedDataBagItem.load(new_resource.ssl_databag,
                                                new_resource.ssl_databag_item || new_resource.name,
                                                ssl_secret)

    directory ssl_dir do
      action :create
      mode "0750"
      groupe "sysadmin"
    end

    file "#{ssl_dir}/#{ssl_cert}" do
      action :create_if_missing

    end
  end

  template ::File.join(node['haproxy']['tmp_config_dir'], "#{new_resource.name}-0frontend.cfg") do
    cookbook new_resource.cookbook 
    source new_resource.template
    mode "0644"

    variables( 
              :name => new_resource.name,
              :mode => new_resource.mode,
              :bind_address => new_resource.bind_address,
              :bind_port => new_resource.bind_port,
              :ssl => new_resource.ssl,
              :ssl_cert => new_resource.ssl_cert,
              :options => new_resource.options,
              :timeout_client => new_resource.timeout_client,
              :maxconn => new_resource.maxconn,
              :raw_config => new_resource.raw_config,
              :default_backend => new_resource.default_backend
             )
    notifies :create, "template[#{node['haproxy']['config']}]"
  end

  new_resource.updated_by_last_action(true)
end


action :delete do
  # Dont forget to change action :create if you change this ; we can't declare this at the top :(
  ssl_cert = new_resource.ssl_cert || "#{new_resource.name}.pem"
  ssl_dir = "#{node['haproxy']['conf_dir']}/ssl"

  warnmsg = "Deleting HAProxy frontend config for #{new_resource.name}"
  log warnmsg do
    level :warn 
    action :nothing
  end
  # Delete the snippets, force a refresh of the main config, which will force a reload
  file ::File.join node['haproxy']['tmp_config_dir'], "#{new_resource.name}-frontend.cfg" do
    action :delete
    notifies :write, "log[#{warnmsg}]"
    notifies :create, "template[#{node['haproxy']['config']}]"
  end

  file "#{ssl_dir}/#{ssl_cert}" do
    action :delete
  end

  new_resource.updated_by_last_action(true)
end
