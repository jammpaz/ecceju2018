# spec/dockerfile_app_spec.rb

require 'serverspec'
require 'docker-api'
require 'json'

describe 'Dockerfile.website' do
  before(:all) do
    @image = Docker::Image.build_from_dir('.', {'dockerfile' => 'Dockerfile.website'}) do |v|
      if ( log = JSON.parse(v) ) && log.has_key?("stream")
        $stdout.puts log['stream']
      end
    end
    @image.tag('repo' => 'jammpaz/website', 'tag' => '0.0.1')
    set :backend, :docker
    set :docker_image, @image.id
  end

  describe 'Configuration' do
    describe port(80) do
      it { should be_listening }
    end
  end

  describe 'Website content' do
    describe file('/usr/share/nginx/html/index.html') do
        it { should exist }
    end

    describe file('/usr/share/nginx/html/feed.xml') do
        it { should exist }
    end

    describe file('/usr/share/nginx/html/404.html') do
        it { should exist }
    end

    describe file('/usr/share/nginx/html/about') do
      it { should be_directory }
    end

    describe file('/usr/share/nginx/html/assets') do
      it { should be_directory }
    end
  end
end
