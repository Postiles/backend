#!/bin/bash
kill `cat ./tmp/pids/unicorn.pid`
unicorn_rails -c config/unicorn.rb -E development -D
