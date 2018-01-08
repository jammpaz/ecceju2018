#!/bin/bash
set -e

echo 'Running devrunner tests...'

rspec $(pwd)/devtools/spec/dockerfile_devrunner_spec.rb
