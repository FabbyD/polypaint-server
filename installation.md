# Installation on Ubuntu 16.04

This installation process is basically a copy paste from [here][1]

## Ruby

First, we obviously need Ruby. Do **not** install Ruby using apt-get as it will install it system-wide and you will most definetely have permissions problems. Instead, you can use `rbenv`.

Install dependencies for rbenv and Ruby
```
sudo apt-get update
sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
```

Install rbenv
```
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

source ~/.bashrc
```

Get ruby-build which is a plugin for rbenv that enables the `rbenv install` command
```
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

Let's finally install Ruby and make its version the default one!
```
rbenv install 2.3.1
rbenv global 2.3.1
```

Verify that it installed correctly
```
$ ruby -v
Output
ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-linux]
```

## Gems, truely outrageous
Gems are packages that extend the functionality of Ruby. We will want to install Rails through the gem command. We will also install the bundler gem to manage application dependencies.
```
gem install bundler
```

## Rails
Moving on to rails!
```
gem install rails
```

rbenv works by creating a directory of shims, which point to the files used by the Ruby version that's currently enabled. Through the rehash sub-command, rbenv maintains shims in that directory to match every Ruby command across every installed version of Ruby on your server. Whenever you install a new version of Ruby or a gem that provides commands, you should run:
```
rbenv rehash
```

Verify that rails has been installed correctly
```
rails -v
```

## JavaScript Runtime

A few Rails features, such as the Asset Pipeline, depend on a JavaScript Runtime. We will install Node.js to provide this functionality.
```
cd /tmp
\curl -sSL https://deb.nodesource.com/setup_6.x -o nodejs.sh
cat /tmp/nodejs.sh | sudo -E bash -
sudo apt-get install -y nodejs
```

There you go! You should be all set for Ruby on Rails! All you need to do in order to run this server now is to install all gems this project depends on with bundler.
```
bundle install
```

And finally run the server.
```
rails server
```

 [1]: https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04
