#!/bin/bash
set -e
REPO_TAG='jammpaz/devrunner:0.0.2'

docker run --rm \
           -v $(pwd)/website/:/website \
           -w /website \
           $REPO_TAG \
           sh -c "htmlproofer ./_site --disable-external --trace"
