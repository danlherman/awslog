name              'awslogs'
maintainer        'Dan Herman'
maintainer_email  'dherman@intratechs.com'
license           'Apache 2.0'
description       'Installs awslogs client and sets up log tracking'
# long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.0.1'

%w{ redhat centos scientific fedora ubuntu debian amazon }.each do |os|
  supports os
end
