#
# Cookbook Name:: hazelcast
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory File.dirname(node['hazelcast']['config_file']) do
  owner node['hazelcast']['config_user']
  group node['hazelcast']['config_group']
  mode "0755"
  action :create
end

template node['hazelcast']['config_file'] do
  owner node['hazelcast']['config_user']
  group node['hazelcast']['config_group']
  source "hazelcast.xml.erb"
end
