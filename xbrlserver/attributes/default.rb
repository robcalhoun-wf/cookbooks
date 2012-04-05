include_attribute "hazelcast"
include_attribute "tomcat"

override['python']['install_method'] = 'source'
override['python']['version'] = '3.2'
override['python']['checksum'] = '7bfd5ff6c13cb234acf9561185361ab10787baf8ffdd128889eaa16d21eb5c19'
#override['java']['install_flavor'] = "sun"

override["tomcat"]["port"] = 80
override["tomcat"]["ssl_port"] = 443
override["tomcat"]["use_ssl"] = true
override["tomcat"]["java_options"] = "-Xmx2048M -Djava.awt.headless=true -Dhazelcast.config=#{hazelcast['config_file']}"

default['xbrlserver']['deploy']['authorized_keys'] = []
default['xbrlserver']['tmp_dir'] = "/tmp/xbrlserver"
default['xbrlserver']['python_bin'] = "/usr/local/bin/python3.2"
default['xbrlserver']['arelle_module'] = "arelle.CntlrBasic"
default['xbrlserver']['home'] = "/var/xbrlserver"
default['xbrlserver']['cache'] = "/var/xbrlserver/cache"
default['xbrlserver']['business_rules'] = "/var/xbrlserver/business_rules"
default['xbrlserver']['default_business_rules'] = []
default['xbrlserver']['arelle_workers'] = 2

override["hazelcast"]["config_user"] = node['tomcat']['user']
override["hazelcast"]["config_group"] = node['tomcat']['group']

# routes = default[:mongrel2][:server][:main][:hosts][:localhost][:routes]
# routes["/validate"] = {
#   :type => :proxy,
#   :addr => "127.0.0.1",
#   :port => 3000
# }


#set[:mongrel2][:server][:main][:ssl] = true
#set[:mongrel2][:server][:main][:self_signed_cert] = true
#set[:mongrel2][:server][:main][:port] = 443

# main_ssl = default[:mongrel2][:server][:main_ssl]
# main_ssl[:uuid] = "219e0c5e-e928-11e0-b306-080027e07de9"
# main_ssl[:name] = "main_ssl"
# main_ssl[:default_host] = 'localhost'
# main_ssl[:hosts] = default[:mongrel2][:server][:main][:hosts]
# main_ssl[:port] = 443
# main_ssl[:ssl] = true
# main_ssl[:self_signed_cert] = true

arelle = default['xbrlserver']['arelle']
arelle['repository'] = "git://github.com/rheimbuch/Arelle.git"
arelle['reference'] = 'lxml'


