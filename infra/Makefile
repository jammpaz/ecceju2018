arrange_test_docker_website:
	rm -rf $(shell pwd)/infra/_site
	cp -R $(shell pwd)/website/_site $(shell pwd)/infra/_site 2>/dev/null

test_and_build_docker_website: arrange_test_docker_website
	docker run \
	  --rm \
	  --name test_website \
	  -v $(shell pwd)/infra:/infra \
	  -v /var/run/docker.sock:/var/run/docker.sock \
	  -w /infra \
	  faustoc/dockertester:0.0.1 \
	  rspec spec/dockerfile_website_spec.rb

upload_docker_website:
	docker tag jammpaz/website:test registry.heroku.com/jammpaz-website-$(value env)/web
	@docker login --username=_ --password=$(TOKEN) registry.heroku.com
	docker push registry.heroku.com/jammpaz-website-$(value env)/web

