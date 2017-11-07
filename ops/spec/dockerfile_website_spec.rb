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
    set :os, family: :redhat
    set :docker_image, @image.id
  end

  describe 'Dependencies' do
    describe package('httpd') do
        it { should be_installed }
    end
  end

  describe 'Configuration' do
    describe port(80) do
      it { should be_listening }
    end

    describe user('website') do
      it { should exist }
    end
  end
end
