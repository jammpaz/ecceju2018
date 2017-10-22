#!/bin/bash
set -e
REPO_TAG='jammpaz/devrunner:0.0.1'

docker run --rm \
           -v $(pwd)/website/:/website \
           -w /website \
           -v gems_data:/usr/local/bundle/ \
           --name devrunner \
           $REPO_TAG \
           bundle install
