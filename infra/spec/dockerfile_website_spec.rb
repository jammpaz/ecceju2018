require 'serverspec'
require 'docker-api'
require 'json'

describe 'Dockerfile.website' do
  before(:all) do
    image = Docker::Image.build_from_dir('.', {'dockerfile' => 'Dockerfile.website'}) do |v|
      if ( log = JSON.parse(v)  ) && log.has_key?("stream")
        $stdout.puts log['stream']
      end
    end
    image.tag('repo' => 'ecceju/website', 'tag' => 'test')

    @container = Docker::Container.create(
      'name' => 'ecceju_website_test',
      'Image' => 'ecceju/website:test',
      'Env' => [ 'PORT=8080' ]
    )
    set :backend, :docker
    set :docker_container, @container.id
    @container.start
  end

  after(:all) do
    @container.stop
    @container.delete
  end

  describe 'Configuration' do
    describe command('echo $PORT') do
      its(:stdout) { should match /8080/ }
    end

    describe port(8080) do
      it { should be_listening }
    end
  end

  describe 'Website content' do
    describe file('/usr/local/apache2/htdocs/index.html') do
        it { should exist }
    end

    describe file('/usr/local/apache2/htdocs/feed.xml') do
        it { should exist }
    end

    describe file('/usr/local/apache2/htdocs/404.html') do
        it { should exist }
    end

    describe file('/usr/local/apache2/htdocs/acerca-de') do
      it { should be_directory }
    end

    describe file('/usr/local/apache2/htdocs/inscripciones') do
      it { should be_directory }
    end

    describe file('/usr/local/apache2/htdocs/ministerios') do
      it { should be_directory }
    end

    describe file('/usr/local/apache2/htdocs/musica') do
      it { should be_directory }
    end

    describe file('/usr/local/apache2/htdocs/noticias') do
      it { should be_directory }
    end

    describe file('/usr/local/apache2/htdocs/programacion') do
      it { should be_directory }
    end

    describe file('/usr/local/apache2/htdocs/assets') do
      it { should be_directory }
    end

    describe file('/usr/local/apache2/htdocs/fonts') do
      it { should be_directory }
    end

    describe file('/usr/local/apache2/htdocs/js') do
      it { should be_directory }
    end
  end
end
