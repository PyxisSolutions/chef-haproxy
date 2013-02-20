# haproxy_frontend resource provider

action :create do

  template File.join(node['haproxy']['tmp_config_dir'], "#{new_resource.name}-frontend.cg") do
    cookbook new_resource.cookbook 
    source new_resource.template

    variables( new_resource )
    notifies :create, "template[#{node['haproxy']['config']}]"
  end

  new_resource.updated_by_last_action(true)
end


action :delete do

  warnmsg = "Deleting HAProxy frontend config for #{new_resource.name}"
  log warnmsg do
    level :warn 
    action :nothing
  end
  # Delete the snippets, force a refresh of the main config, which will force a reload
  file File.join node['haproxy']['tmp_config_dir'], "#{new_resource.name}-frontend.cfg" do
    action :delete
    notifies :write, "log[#{warnmsg}]"
    notifies :create, "template[#{node['haproxy']['config']}]"
  end
  new_resource.updated_by_last_action(true)
end
