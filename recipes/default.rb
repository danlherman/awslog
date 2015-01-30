
# Install awslogs on server
	if platform_family?('rhel')    
		yum_package "awslogs" do
		  action :install
		end
	end

  template "/tmp/awslogs.conf" do
    source "awslogs.conf.erb"
    owner "root"
    group "root"
    mode 0755
		variables(:awslogs => node[:awslogs])
    action :create
  end

  execute "download awslogs setup script" do
    if platform_family?('debian')
			command "wget https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py"
			action :run
    end
	end
	execute "run awslogs setup script" do
    if platform_family?('debian')
			command "python ./awslogs-agent-setup.py -n -r us-east-1 -c /tmp/awslogs.conf"
      action :run
    end
	end	


# Template for /etc/awslogs/awscli.conf
 etc_folder = '/etc/awslogs'
 state_path = '/var/lib/awslogs/agent-state'
 if platform_family?('debian')
   etc_folder = '/var/awslogs/etc'
   state_path = '/var/awslogs/state'
 end

 template "#{etc_folder}/awscli.conf" do
    source "awscli.conf.erb"
    owner "root"
    group "root"
    mode 0755
		variables(:awslogs => node[:awslogs], :state_path => state_path)
    action :create
  end

# Template for /etc/awslogs/awslogs.conf
 template "#{etc_folder}/awslogs.conf" do
    source "awslogs.conf.erb"
    owner "root"
    group "root"
    mode 0755
		variables(:awslogs => node[:awslogs])
    action :create
  end

# Start the awslogs service and make sure it starts at boot
  service "awslogs" do
    action [:enable, :start]
  end

