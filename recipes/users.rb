#
# Cookbook Name:: tomcat
# Recipe:: users
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#
# Copyright 2010-2012, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

service "tomcat" do
  case node['platform_family']
  when 'rhel', 'fedora'
    service_name "tomcat"
    supports :restart => true, :status => true
  when 'debian'
    service_name "tomcat"
    supports :restart => true, :reload => false, :status => true
  when 'smartos'
    # SmartOS doesn't support multiple instances
    service_name 'tomcat'
    supports :restart => false, :reload => false, :status => true
  else
    service_name "tomcat"
  end
  action [:start, :enable]
  notifies :run, "execute[wait for tomcat]", :immediately
  retries 4
  retry_delay 30
end

execute "wait for tomcat" do
  command 'sleep 5'
  action :nothing
end

template "#{node["tomcat"]["config_dir"]}/tomcat-users.xml" do
  source 'tomcat-users.xml.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :users => TomcatCookbook.users,
    :roles => TomcatCookbook.roles,
  )
  notifies :restart, 'service[tomcat]'
end
