define :execute_sql_file, variables: {}, template_cookbook: "mysql-user", template_source: 'create_user.sql.erb' do
  template params[:template_path] do
    source      params[:template_source]
    cookbook    params[:template_cookbook]
    variables   params[:variables]
    owner       "root"
    group       "root"
    mode        "0755"
    action      :create
  end

  execute "execute_sql_script" do
    parameters    =   ""
    parameters   +=   " #{params[:binary_args]}" unless params[:binary_args].empty?
    parameters   +=   " -u #{params[:root_user]}"
    parameters   +=   " -p\"#{params[:root_password]}\"" unless params[:root_password].empty?
    
    sudo          =   params[:use_sudo] ? "sudo " : ""
    
    command "#{sudo}#{params[:binary_path]}#{parameters} < \"#{params[:template_path]}\""
  end

  file params[:template_path] do
    action :delete
    only_if { File.exists?(params[:template_path]) }
  end
end
