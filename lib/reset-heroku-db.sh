#!/usr/bin/env bash

heroku pg:reset --confirm polypaint-pro
cat populate_database.rb | heroku run console --no-tty
