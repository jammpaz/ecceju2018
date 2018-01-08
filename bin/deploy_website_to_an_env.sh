#!/bin/bash
set -e
env=$1
repository="registry.heroku.com/jammpaz-website-$env/web"
docker login --username=_ --password=$(heroku auth:token) registry.heroku.com
docker tag jammpaz/website:test $repository
docker push $repository
