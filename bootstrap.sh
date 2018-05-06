#!/usr/bin/env bash

# update
sudo apt-get install software-properties-common
sudo apt-get install -y language-pack-en-base
sudo add-apt-repository ppa:chris-lea/redis-server
sudo apt-get update
sudo apt-get install python-software-properties vim curl expect debconf-utils git-core -q -y
sudo apt-get install build-essential zlib1g-dev libssl-dev openssl libcurl4-openssl-dev libreadline6-dev -q -y
sudo apt-get install libpcre3 libpcre3-dev imagemagick postgresql postgresql-contrib libpq-dev -q -y
sudo apt-get install postgresql-server-dev-9.5 redis-server advancecomp gifsicle jhead jpegoptim -q -y
sudo apt-get install libjpeg-turbo-progs optipng pngcrush pngquant gnupg2 screen mc -q -y

# configure postgres

sudo cp /home/vagrant/apps/configs/pg_hba.conf /etc/postgresql/9.5/main
sudo cp /home/vagrant/apps/configs/postgresql.conf /etc/postgresql/9.5/main
sudo chown -R postgres:postgres /etc/postgresql/9.5/main
sudo chmod 0640 /etc/postgresql/9.5/main/pg_hba.conf
sudo chmod 0644 /etc/postgresql/9.5/main/postgresql.conf
sudo service postgresql restart


# create postgres user
sudo -u postgres -i createuser --superuser -Upostgres vagrant
sudo -u postgres psql -c "ALTER USER vagrant WITH PASSWORD 'password';"
sudo bash -c "echo 'vm.swappiness = 0' >> /etc/sysctl.conf"

# ruby
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -sSL https://get.rvm.io | bash -s stable
echo 'gem: --no-document' >> ~/.gemrc
source /home/vagrant/.rvm/scripts/rvm
rvm install 2.3.4
rvm --default use 2.3.4 # If this error out check https://rvm.io/integration/gnome-terminal
# nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# discourse

cd apps/discourse
# move tmp outside of share. See https://github.com/rails/sprockets/issues/283
sudo rm -rf tmp
sudo mkdir /tmp/rails-app
sudo chmod 0777 /tmp/rails-app
sudo ln -s /tmp/rails-app tmp

nvm install node
nvm alias default node
npm install -g svgo
gem install bundler mailcatcher
bundle install

# run this if there was a pre-existing database
bundle exec rake db:drop
RAILS_ENV=test bundle exec rake db:drop

# time to create the database and run migrations
bundle exec rake db:create db:migrate
RAILS_ENV=test bundle exec rake db:create db:migrate

# run server, mailer, sidekiq in screen
cd .. 
./vagrant.screen

# run the specs (optional)
# bundle exec rake autospec # CTRL + C to stop

# launch discourse
# bundle exec rails s -b 0.0.0.0 # open browser on http://localhost:3000 and you should see Discourse

