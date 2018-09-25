#
# Cookbook:: a2
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

apt_update 'update system' do
  action :periodic
end

automate_archive = "#{Chef::Config[:file_cache_path]}/chef-automate_linux_amd64.zip"

sysctl 'vm.max_map_count' do
  value 262144
end

sysctl 'vm.dirty_expire_centisecs' do
  value 20000
end

package 'zip'

hostname 'automate-deployment.test'

remote_file automate_archive do
  source 'https://packages.chef.io/files/current/automate/latest/chef-automate_linux_amd64.zip'
end

execute 'Extract Automate' do
  command "unzip #{automate_archive} -d /usr/sbin"
  not_if { ::File.exist?('/usr/sbin/chef-automate') }
  notifies :run, 'execute[Create Config]', :immediately
end

if node['a2'].attribute?('version')
  directory '/tmp/manifests' do
    action :create
  end

  remote_file '/tmp/manifests/current.json' do
    source lazy { "https://packages.chef.io/manifests/current/automate/#{node['a2']['version']}.json" }
    notifies :run, 'execute[Deploy Automate Version]', :immediately
  end

  node.default['a2']['install_opts'] = "  --manifest-dir /tmp/manifests/ --channel current --upgrade-strategy none --skip-preflight"
end

execute 'Create Config' do
  command 'chef-automate init-config'
  cwd Chef::Config[:file_cache_path]
  creates ::File.join(Chef::Config[:file_cache_path], 'config.toml')
end

execute 'Deploy Automate' do
  command "yes | chef-automate deploy #{node['a2']['install_opts']}  config.toml"
  cwd Chef::Config[:file_cache_path]
  subscribes :run, 'execute[Create Config]', :immediately
  action :nothing
end

if node['a2']['licensed']
  automate_license = "#{Chef::Config[:file_cache_path]}/automate.license"

  cookbook_file automate_license do
    source 'automate.license'
    sensitive true
  end

  execute 'Apply license' do
    command "chef-automate license apply $(cat #{automate_license})"
  end

  file automate_license do
    action :delete
  end
end
