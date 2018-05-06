if node[:mysql][:admin_user] && !node[:mysql][:admin_user].empty? && node[:mysql][:admin_user][:username] && node[:mysql][:admin_user][:password]
  execute_sql_file do
    template_path       '/tmp/create_user.sql'
    template_source     'create_user.sql.erb'
    
    binary_path         node[:mysql][:binary][:path]
    binary_args         node[:mysql][:binary][:arguments]
    
    root_user           node[:mysql][:user][:root_user]
    root_password       node[:mysql][:user][:root_password]
    
    use_sudo            node[:mysql][:user][:use_sudo]
  end
else
  Chef::Log.info("Seems like the node['mysql']['admin_user']-hash hasn't been set. Set the username and password to create an admin user.")
end
