resource_name :mysql_user

property :username,          String, name_attribute: true
property :password,          String, required: true

property :root_user,         String, default: 'root'
property :root_password,     String

property :binary_path,       String, required: true
property :binary_args,       String

property :use_sudo,          Boolean, default: false

property :template_cookbook, String, default: "mysql-user"
property :template_source,   String, default: "create_user.sql.erb"
property :template_path,     String, default: "/tmp/create_user.sql"

action :create do
  action_execute_sql
end

action :execute_sql do
  template new_resource.template_path do
    source      new_resource.template_source
    cookbook    new_resource.template_cookbook
    
    variables(
      root_user:      new_resource.root_user,
      root_password:  new_resource.root_password,
      username:       new_resource.username,
      password:       new_resource.password,
    )
    
    owner       "root"
    group       "root"
    mode        "0755"
    
    action      :create
  end

  execute "execute_sql_script" do
    parameters    =   ""
    parameters   +=   " #{new_resource.binary_args}" unless new_resource.binary_args.empty?
    parameters   +=   " -u #{new_resource.root_user}"
    parameters   +=   " -p\"#{new_resource.root_password}\"" unless new_resource.root_password.empty?
    
    sudo          =   new_resource.use_sudo ? "sudo " : ""
    
    command "#{sudo}#{new_resource.binary_path}#{parameters} < \"#{new_resource.template_path}\""
  end

  file new_resource.template_path do
    action :delete
    only_if { File.exists?(new_resource.template_path) }
  end
end
