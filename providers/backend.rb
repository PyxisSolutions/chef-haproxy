# haproxy_backend resource provider



action :create do

  servers = []
  if new_resource.servers_config
    servers = new_resource.servers_config
  elsif new_resource.servers_name
    log("NOT IMPLEMENTED"){ level :fatal}
    raise "Not implemented yet, sorry"
  elsif new_resource.servers_search
    result = search(:node, new_resource.servers_search)
    unless result.empty?
      result.each do |srv|
        servers << "\tserver #{srv['hostname']} #{srv['ipaddress']}:#{new_resource.server_port} maxconn #{new_resource.maxconn} weight #{new_resource.weight} check" 
      end
    else
      log("No server found for backend #{new_resource.name} using search #{new_resource.servers_search}"){ level :error}
    end
  else 
    log("You need to specify at least one way to get your server list!"){ level :fatal}
    raise "Missing server list for backend #{new_resource.name}"
  end

  if new_resource.ssl
    # See also http://cbonte.github.com/haproxy-dconv/configuration-1.5.html#check-ssl 
    new_resource.options << "ssl-hello-chk"
  end

  template ::File.join(node['haproxy']['tmp_config_dir'], "#{new_resource.name}-backend.cfg") do
    cookbook new_resource.cookbook 
    source new_resource.template
    mode "0644"

    variables(
      :name => new_resource.name,
      :mode => new_resource.mode,
      :options => new_resource.options,
      :timeout_server => new_resource.timeout_server,
      :raw_config => new_resource.raw_config,
      :default_server => new_resource.default_server,
      :servers => servers
    )
    notifies :create, "template[#{node['haproxy']['config']}]"
  end

  new_resource.updated_by_last_action(true)
end


action :delete do
  warnmsg = "Deleting HAProxy backend config for #{new_resource.name}"
  log warnmsg do
    level :warn 
    action :nothing
  end
  # Delete the snippets, force a refresh of the main config, which will force a reload
  file ::File.join node['haproxy']['tmp_config_dir'], "#{new_resource.name}-backend.cfg" do
    action :delete
    notifies :write, "log[#{warnmsg}]"
    notifies :create, "template[#{node['haproxy']['config']}]"
  end
end

