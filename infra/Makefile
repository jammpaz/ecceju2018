BUILD_DEBUG ?= yes

arrange_test_docker_website:
	rm -rf $(shell pwd)/infra/_site
	cp -R $(shell pwd)/website/_site $(shell pwd)/infra/_site

test_and_build_docker_website: arrange_test_docker_website
	docker run \
	  --rm \
	  --name test_website \
	  -v $(shell pwd)/infra:/infra \
	  -v /var/run/docker.sock:/var/run/docker.sock \
	  -w /infra \
	  faustoc/dockertester:0.0.1 \
	  rspec spec/dockerfile_website_spec.rb

define upload_website_forward_env
	docker tag ecceju/website:test registry.heroku.com/$(1)/web
	@docker login --username=_ --password=$(2) registry.heroku.com
	docker push registry.heroku.com/$(1)/web
	heroku container:release web --app $(1)
endef

upload_docker_website_qa:
	$(call upload_website_forward_env,ecceju-qa,$(TOKEN))

upload_docker_website_prod:
	$(if $(filter no, $(BUILD_DEBUG)), \
	  $(call upload_website_forward_env,ecceju,$(TOKEN)), \
	  @echo "INFO: This build will not be deployed on production environment")
