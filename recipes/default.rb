#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

include_recipe "java"

tomcat_pkgs = case node["platform_family"]
  when "debian"
    ["tomcat6","tomcat6-admin"]
  when "rhel", "fedora"
    ["tomcat6","tomcat6-admin-webapps"]
  else
    ["tomcat6"]
end

tomcat_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

service "tomcat" do
  service_name "tomcat6"
  case node["platform_family"]
  when "rhel","fedora"
    supports :restart => true, :status => true
  when "debian"
    supports :restart => true, :reload => true, :status => true
  end
  action [:enable, :start]
end

case node["platform_family"]
when "rhel","fedora"
  template "/etc/sysconfig/tomcat6" do
    source "sysconfig_tomcat6.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, resources(:service => "tomcat")
  end
else
  template "/etc/default/tomcat6" do
    source "default_tomcat6.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, resources(:service => "tomcat")
  end
end

template "/etc/tomcat6/server.xml" do
  source "server.xml.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "tomcat")
end

template "/etc/tomcat6/logging.properties" do
  source "logging.properties.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[tomcat]"
end
