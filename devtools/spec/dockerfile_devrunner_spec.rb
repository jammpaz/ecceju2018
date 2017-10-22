# spec/dockerfile_dev_spec.rb

require 'serverspec'
require 'docker-api'
require 'json'

describe 'Dockerfile.devrunner' do
  before(:all) do
    @image = Docker::Image.build_from_dir('.', {'dockerfile' => 'Dockerfile.devrunner'}) do |v|
      if ( log = JSON.parse(v) ) && log.has_key?("stream")
        $stdout.puts log['stream']
      end
    end
    @image.tag('repo' => 'jammpaz/devrunner', 'tag' => '0.0.1')
    set :backend, :docker
    set :os, family: :debian
    set :docker_image, @image.id
  end

  describe 'Dependencies' do
    context 'ruby' do
      it 'has to be installed' do
        response = command('sh -c "ruby -v"')
        expect(response.stdout).to match '2.4.2'
      end
    end
    describe package('jekyll') do
        it { should be_installed.by('gem') }
    end
    describe package('bundler') do
        it { should be_installed.by('gem') }
    end
  end

  describe 'Configuration' do
    describe user('developer') do
      it { should exist }
      it { should belong_to_group 'sudo' }
      it { should have_home_directory '/home/developer' }
    end
    describe file('/website/') do
      it { should be_owned_by 'developer' }
    end
    describe file('/usr/local') do
      it { should be_owned_by 'developer' }
    end
  end
end
