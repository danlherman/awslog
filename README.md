# awslogs

Description
===========

This cookbook facilitates the setup and config of the awslogs client on Amazon Ec2 instances


AWS Credentials
===============

The default recipe will look for a data bag defined by node['awslogs']['aws_access_key_id']  and node['awslogs']['aws_secret_access_key']. These credentials should be for a user with the minimum access to be able to add logs to cloudwatch. 

Example policy for awslog user:

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:*"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}

See http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/QuickStartEC2Instance.html for more information.


Sample Custom JSON
==================

Fill in your awslog user credentials and specify logs for each layer. In the example below the log files messages, and secure are for the rails-app layer, and syslog, modsec_audit.log, access.log, and error.log are for the proxy server.

The environment is used as a prefix for the Log Group name (i.e. test_access.log, or prod_access.log)

The layer name should be the layers short name.


E.G.
```json
{  
   "awslogs":{  
      "aws_access_key_id":"<-aws-access-key->",
      "aws_secret_access_key":"<-aws-secret-access-key->",
      "environment":"test",
      "rails-app":{  
         "logs":[  
            "/var/log/messages",
            "/var/log/secure",
            "/srv/www/myapp/shared/log/unicorn.stderr.log",
            "/srv/www/myapp/shared/log/production.log"
         ]
      },
      "proxy":{  
         "logs":[  
            "/var/log/syslog",
            "/var/log/modsec_audit.log",
            "/var/log/apache2/error.log",
            "/var/log/apache2/access.log"
         ]
      }
   }
}


   

Recipes
=======

default
-------

The default recipe install the awslog client and sets up the logging for the specified log files.

Attributes
==========

TODO...



TODO
====

* Egress rules
* Apply security groups to instances, elbs, vpcs, etc


License and Author
==================

* Author:: Dan Herman (<dherman@intratechs.com>)

(c) 2014, Dan Herman <dherman@intratechs.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.



