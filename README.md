# Setup virtual machine running discourse

## Windows

Tested with Windows7 Pro, Vagrant 2.0.1, Virtualbox 5.1.3

To setup working development environment on windows machine
you need to install the following software:

* Virtualbox
* Vagrant
* Git
* Putty on Windows

By default VM is configured with two CPU cores and 3GB of RAM. This can be
changed in Vagrantfile

After you installed all necessary software open your Windows Command Processor
AS ADMINISTRATOR and run:

`git clone https://github.com/alfabetagama/discourse-vagrant.git`

`cd discourse-vagrant`

`provision.bat`

IF YOU DON'T PROVISION AS ADMIN SYMLINKING WONT WORK AND PROVISIONING
WILL FAIL!!!


This command will clone the discourse repo, setup ubuntu 16.04 VM,
setup all necessary software and start discourse server in development mode


## Ports and stuff

From host you can access discourse files in discourse-vagrant/apps/discourse.

Inside VM files are mounted via nfs in /home/vagrant/apps/discourse



**SSH should be available on localhost:2222**

You can login into virtual machine with putty or ssh using **vagrant:vagrant** as your credentials



With server running, discourse app should be available on host on **http://localhost:3000** and vm IP on port 3000

**Postgres** database should be available on port 5432 on localhost and vm IP on same port

You can access database with tool such as HeidiSQL using vagrant:password as your credentials

**Mailcatcher** should be available on http://localhost:1080



## Admin account

To create admin account ssh into virtual machine and run:

`cd apps/discourse`

`bundle exec rake admin:create`



## Screens

Couple of screens will be launched inside VM at the end of provisioning
including rails server, sidekiq and mailcatcher.


To list them, run:

`screen -ls`


To attach to rails server screen run:

`screen -r {pid}.server`

To detach press CTRL+a d

To kill all screens and processes and restart them go to apps directory and run:

`./vagrant.screen`



## Tasks

To start discourse manually ssh into virtual machine and:

`cd apps/discourse`

`bundle exec rails s -b 0.0.0.0`

To run the spec:

`bundle exec rake autospec`


## Linux/Mac

Putty is not needed here, but otherwise could probably work with minor modifications and a sudo here and there

