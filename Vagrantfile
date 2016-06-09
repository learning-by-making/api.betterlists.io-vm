# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # enable the plugin https://github.com/gosuri/vagrant-env
  # config.env.enable
  config.env.load('.env.local', '.env')

  config.vm.hostname = 'api-betterlist-io'
  
  config.vm.box = 'AlbanMontaigu/boot2docker'

  # https://github.com/leighmcculloch/vagrant-docker-compose
  config.vm.provision :docker_compose,
                      yml: '/vagrant/docker-compose.yml',
                      # don't rebuild if environment variable 'DOCKER_COMPOSE_REBUILD' is not set or
                      # if it is equal to 'false' (environment variables return a string)
                      rebuild: !ENV['DOCKER_COMPOSE_REBUILD'].nil? &&
                        ENV['DOCKER_COMPOSE_REBUILD'].strip.downcase != 'false',
                      run: 'always'
end
