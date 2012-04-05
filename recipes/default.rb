python_pip "#{node['arelle']['path-to-tarball']/arelle-#{node['arelle']['version']}.tar.gz" do
  version "latest"
  action :install
end
