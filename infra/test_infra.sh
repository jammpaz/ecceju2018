#!/bin/bash
set -e

echo 'Running infrastructure tests...'

cp -r $(pwd)/website/_site $(pwd)/infra/
rspec $(pwd)/infra/spec/dockerfile_website_spec.rb
