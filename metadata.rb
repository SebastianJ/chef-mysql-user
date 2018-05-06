name             "mysql-user"
maintainer       "Sebastian Johnsson"
maintainer_email "sebastian.johnsson@gmail.com"
license          "MIT"
description      "User management for MySQL"
version          "0.1"

%w{ ubuntu debian }.each do |os|
  supports os
end

%w{ mysql }.each do |cb|
  depends cb
end
