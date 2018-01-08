#!/bin/bash
set -e
REPO_TAG='jammpaz/devrunner:0.0.1'

docker run --rm \
           -v $(pwd)/website/:/website \
           -w /website \
           -v gems_data:/usr/local/bundle/ \
           --name devrunner \
           -p 4000:4000 \
           $REPO_TAG \
           bundle exec jekyll server --host 0.0.0.0
