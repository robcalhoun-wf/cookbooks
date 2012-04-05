hc = default['hazelcast']

default['hazelcast']['config_file'] = "/etc/hazelcast/hazelcast.xml"
default['hazelcast']['config_user'] = "root"
default['hazelcast']['config_group'] = "root"

default['hazelcast']['group']['name'] = 'dev'
default['hazelcast']['group']['password'] = 'dev-pass'

default['hazelcast']['port'] = 5701


default['hazelcast']['tcp_ip']['enabled'] = false
default['hazelcast']['tcp_ip']['interface'] = '127.0.0.1'


default['hazelcast']['aws']['access_key'] = ENV['HAZELCAST_AWS_ACCESS_KEY']
default['hazelcast']['aws']['secret_key'] = ENV['HAZELCAST_AWS_ACCESS_SECRET']
default['hazelcast']['aws']['region'] = "us-east-1"
default['hazelcast']['aws']['security_group'] = ENV['HAZELCAST_AWS_SECURITY_GROUP']
default['hazelcast']['aws']['tag_key'] = nil
default['hazelcast']['aws']['tag_value'] = nil
default['hazelcast']['aws']['enabled'] = !!(default['hazelcast']['aws']['access_key'] &&default['hazelcast']['aws']['secret_key'] && default['hazelcast']['aws']['security_group'])

default['hazelcast']['multicast']['enabled'] = !default['hazelcast']['aws']['enabled']
default['hazelcast']['multicast']['group'] = '224.2.2.3'
default['hazelcast']['multicast']['port'] = 53327

default['hazelcast']['interfaces']['enabled'] = false
default['hazelcast']['interfaces']['list'] = ["10.10.1.*"]

default['hazelcast']['encryption']['symmetric']['enabled'] = false
default['hazelcast']['encryption']['symmetric']['algorithm'] = "PBEWithMD5AndDES"
default['hazelcast']['encryption']['symmetric']['salt'] = "encryption-salt"
default['hazelcast']['encryption']['symmetric']['password'] = "encription-pass"
default['hazelcast']['encryption']['symmetric']['iteration_count'] = 19

default['hazelcast']['executor_service']['core_pool_size'] = 16
default['hazelcast']['executor_service']['max_pool_size'] = 64
default['hazelcast']['executor_service']['keep_alive_seconds'] = 60

default_q = default['hazelcast']['queues']['default']
default_q['max_size_per_jvm'] = 0
default_q['backing_map_ref'] = 'default'

default_map = default['hazelcast']['maps']['default']
default_map['backup_count'] = 1
default_map['time_to_live_seconds'] = 0
default_map['max_idle_seconds'] = 0
default_map['eviction_policy'] = 'NONE'
default_map['max_size'] = 0
default_map['eviction_percentage'] = 25
default_map['merge_policy'] = "hz.ADD_NEW_ENTRY"
