#!/usr/bin/env bash

heroku pg:reset --confirm polypaint-pro
heroku run rake db:migrate
cat populate_database.rb | heroku run console --no-tty
