include infra/Makefile

override JEKYLL_GEMS = jekyll_gems:/usr/local/bundle
override TASKRUNNER_IMAGE = faustoc/jekyllrunner:0.0.1

userid := 1000
.DEFAULT_GOAL := default

default:
	@echo "ECCEJU website maker!"

new_website:
	docker run \
	  --rm \
	  --name new_website_ecceju \
	  -v $(shell pwd)/website:/website \
	  -w /website \
	  $(TASKRUNNER_IMAGE) \
	  jekyll new .

install_dependencies:
	docker run \
	  --rm \
	  --name install_dependencies \
	  -v $(shell pwd)/website:/website \
	  -v $(JEKYLL_GEMS) \
	  -u $(userid) \
	  -w /website \
	  $(TASKRUNNER_IMAGE) \
	  bundle install

run_website: install_dependencies
	docker run \
	  --rm \
	  --name run_website_ecceju \
	  -v $(shell pwd)/website:/website \
	  -v $(JEKYLL_GEMS) \
	  -w /website \
	  --expose 4000 \
	  $(TASKRUNNER_IMAGE) \
	  bundle exec jekyll serve --host 0.0.0.0

test_website_script:
	docker run \
	  --rm \
	  --name test_website_script \
	  -v $(shell pwd)/website:/website \
	  -v $(JEKYLL_GEMS) \
	  -u $(userid) \
	  -w /website \
	  $(TASKRUNNER_IMAGE) \
	  sh -c "jekyll clean && jekyll build"

test_website_htmlproofer:
	docker run \
	  --rm \
	  --name test_website_htmlproofer \
	  -v $(shell pwd)/website:/website \
	  -v $(JEKYLL_GEMS) \
	  -w /website \
	  $(TASKRUNNER_IMAGE) \
	  sh -c "htmlproofer ./_site --disable-external --trace"

test_all: test_website_script test_website_htmlproofer
