resource_name :mysql_user

property :username,      String, name_attribute: true
property :password,      String, required: true

property :root_user,     String, default: 'root'
property :root_password, String

property :binary_path,   String, required: true
property :binary_args,   String

property :use_sudo,      Boolean, default: false

action :create do
  execute_sql_file do
    template_path       '/tmp/create_user.sql'
    
    variables           {
      root_user:      new_resource.root_user,
      root_password:  new_resource.root_password,
      username:       new_resource.username,
      password:       new_resource.password,
    }
    
    binary_path         new_resource.binary_path
    binary_args         new_resource.binary_args
    
    root_user           new_resource.root_user
    root_password       new_resource.root_password
    
    use_sudo            new_resource.use_sudo
  end
end
