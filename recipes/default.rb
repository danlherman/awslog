
# Install awslogs on server
if platform_family?('rhel')
  yum_package 'awslogs' do
    action :install
  end
end

etc_folder = '/etc/awslogs'
state_path = '/var/lib/awslogs'
if platform_family?('debian')
  etc_folder = '/var/awslogs/etc'
  state_path = '/var/awslogs/state'
end

if platform_family?('debian')
  template '/tmp/awslogs.conf' do
    source 'awslogs.conf.erb'
    owner 'root'
    group 'root'
    mode 0755
    variables(state_path: state_path)
    action :create
  end
end

if platform_family?('debian')
  execute 'download awslogs setup script' do
    command 'wget https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py'
    action :run
  end
end

if platform_family?('debian')
  execute 'run awslogs setup script' do
    command 'python ./awslogs-agent-setup.py -n -r us-east-1 -c /tmp/awslogs.conf'
    action :run
  end
end

# Template for /etc/awslogs/awscli.conf
template "#{etc_folder}/awscli.conf" do
  source 'awscli.conf.erb'
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

# Template for /etc/awslogs/awslogs.conf
template "#{etc_folder}/awslogs.conf" do
  source 'awslogs.conf.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables(state_path: state_path)
  action :create
end

if platform_family?('debian')
  execute 'add agent-state file' do
    command "touch #{state_path}/agent-state"
    action :run
  end
end

# Start the awslogs service and make sure it starts at boot
service 'awslogs' do
  action [:enable, :restart]
end

# Cleanup tmp files
if platform_family?('debian')
  file '/tmp/awslogs.conf' do
    action :delete
  end
  file 'awslogs-agent-setup.py' do
    action :delete
  end
end
