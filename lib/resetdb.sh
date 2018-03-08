#!/usr/bin/env bash

rails db:drop db:create db:migrate
rails runner /home/fabrice/polytechnique/polypaint-server/lib/populate_database.rb
