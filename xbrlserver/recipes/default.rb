#
# Cookbook Name:: xbrlserver
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#include_recipe "apt"
#include_recipe "python"
#include_recipe "java"
#include_recipe "tomcat"
#include_recipe "logrotate"
#include_recipe "hazelcast"

#package "git-core"

#lxml_packages = ['libxml2','libxml2-dev','libxslt1-dev']
#lxml_packages.each{|p| package p}

#python_pip "lxml" do
#  action :install
#end

python_pip "appdirs" do
  action :install
end

python_pip "-e git+#{node['xbrlserver']['arelle']['repository']}@#{node['xbrlserver']['arelle']['reference']}#egg=Arelle" do
  version "latest"
  action :install
end

user "deploy" do
  action :create
  comment "Application deployment user"
  home "/home/deploy"
  shell "/bin/bash"
  supports :manage_home => true
end

group "deploy" do
  members ['deploy']
end

directory "/home/deploy/.ssh" do
  owner "deploy"
  group "deploy"
  mode "0700"
end

template "/home/deploy/.ssh/authorized_keys" do
  source "deploy_authorized_keys.erb"
  owner "deploy"
  group "deploy"
  mode "0600"
end

## Create Tmpfs area for file uploads
directory node[:xbrlserver][:tmp_dir] do
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  mode "0700"
  action :create
end

mount node[:xbrlserver][:tmp_dir] do
  pass 0
  fstype "tmpfs"
  device "/dev/null"
  action [:mount, :enable]
end

directory node[:xbrlserver][:cache] do
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  mode "0755"
  action :create
  recursive true
end

directory node[:xbrlserver][:home] do
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  mode "0755"
  action :create
  recursive true
end

directory node[:xbrlserver][:business_rules] do
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  mode "0755"
  action :create
  recursive true
end

log(ENV) { level :debug }

directory "/etc/xbrlserver" do
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  mode "0755"
  action :create
end

template "/etc/xbrlserver/config.properties" do
  source "xbrlserver-config.properties.erb"
  mode "0755"
end

if ENV.has_key?('BOOTSTRAP_DIR')
  jar = File.expand_path(File.join(ENV['BOOTSTRAP_DIR'], 'web-api-standalone.war'))
  log(jar) { level :debug }
  dest = File.expand_path(File.join(node["tomcat"]["webapp_dir"], 'ROOT.war'))
  
  ruby_block "copy_bootstrap_web_api_jar" do
    block do
      require 'fileutils'
      static_root = File.expand_path(File.join(node["tomcat"]["webapp_dir"], "ROOT"))
      FileUtils.rm_rf(static_root) if File.exists? static_root
      FileUtils.cp(jar, dest)
    end

    notifies :restart, resources(:service => "tomcat")

    action :create
  end

  ruby_block "copy_bootstrop_xbrl_cache" do
    block do
      require 'fileutils'
      source = File.expand_path(File.join(ENV['BOOTSTRAP_DIR'], 'xbrl_cache'))
      dest = File.expand_path(node["xbrlserver"]["cache"])
      FileUtils.cp_r(File.join(source, "."), dest)
    end
  end

  ruby_block "copy_bootstrop_business_rules" do
    block do
      require 'fileutils'
      source = File.expand_path(File.join(ENV['BOOTSTRAP_DIR'], 'business_rules'))
      dest = File.expand_path(node["xbrlserver"]["business_rules"])
      FileUtils.cp_r(File.join(source, "."), dest)
    end
  end
end

