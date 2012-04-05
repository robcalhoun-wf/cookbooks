#
# Cookbook Name:: arelle
# Recipe:: default
#
# Author:: rob.calhoun@webfilings.com

include_recipe "python::pip"

python_pip "appdirs" do
  action :install
end

python_pip "-e git+#{node['arelle']['repository']}@#{node['arelle']['reference']}#egg=Arelle" do
  version "latest"
  action :install
end
