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

case node.platform
when "centos","redhat","fedora"
  include_recipe "jpackage"
end

tomcat_pkgs = value_for_platform(
  ["debian","ubuntu"] => {
    "default" => ["tomcat6","tomcat6-admin", "authbind", "libtcnative-1"]
  },
  ["centos","redhat","fedora"] => {
    "default" => ["tomcat6","tomcat6-admin-webapps"]
  },
  "default" => ["tomcat6"]
)
tomcat_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

service "tomcat" do
  service_name "tomcat6"
  case node["platform"]
  when "centos","redhat","fedora"
    supports :restart => true, :status => true
  when "debian","ubuntu"
    supports :restart => true, :reload => true, :status => true
  end
  action [:enable, :start]
end

case node["platform"]
when "centos","redhat","fedora"
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

cert_dir = File.join(node['tomcat']['config_dir'], 'certs')

directory cert_dir do
  action :create
  owner node["tomcat"]["user"]
  group node["tomcat"]["user"]
  mode  "0500"
  action :create
end

log(ENV) { level :debug }

template File.join(cert_dir, "server.crt") do
  source "tomcat.crt.erb"
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  mode "0400"
  only_if { node["tomcat"]["ssl_cert"] }
  variables :cert => node["tomcat"]["ssl_cert"]
end

template File.join(cert_dir, "server.key") do
  source "tomcat.key.erb"
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  mode "0400"
  only_if { node["tomcat"]["ssl_key"] }
  variables :key => node["tomcat"]["ssl_key"]
end

template File.join(node['tomcat']['config_dir'], "server.xml") do
  source "server.xml.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "tomcat")
end

directory node["tomcat"]["home"] do
  owner "root"
  group node["tomcat"]["group"]
  mode "0775"
  action :create
end


