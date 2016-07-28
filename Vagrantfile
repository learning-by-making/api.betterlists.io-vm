# -*- mode: ruby -*-
# vi: set ft=ruby :

# install Vagrant plugins automatically
# http://stackoverflow.com/a/28801317
# https://github.com/aidanns/vagrant-reload/issues/4#issuecomment-230134083
required_plugins = %w( vagrant-docker-compose vagrant-env vagrant-vbguest )
plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # enable the plugin https://github.com/gosuri/vagrant-env
  # config.env.enable
  config.env.load('.env.local', '.env')

  config.vm.hostname = 'betterlists-vm'

  config.vm.provider 'virtualbox' do |v|
    v.name = 'betterlists-vm'
    v.memory = ENV['VM_MEMORY']
  end
  config.vm.network 'forwarded_port', guest: ENV['WEB_GUEST_PORT'], host: ENV['WEB_HOST_PORT']

  # https://github.com/mitchellh/vagrant/issues/7155#issuecomment-216855120
  config.vm.box = 'bento/ubuntu-16.04'
  # the default user for this box is 'vagrant'
  # config.ssh.username = ENV['VM_USERNAME']

  # create source host folder if it doesn't exist
  FileUtils::mkdir_p ENV['SOURCE_HOST_FOLDER']

  # https://www.vagrantup.com/docs/synced-folders/
  config.vm.synced_folder ENV['SOURCE_HOST_FOLDER'], "/home/#{ENV['VM_USERNAME']}/#{ENV['APP_NAME']}", create: true

  # ansible_local provisioner executes on the guest vm therefore it can read only host files
  # that are shared with the guest vm
  FileUtils.cp(ENV['SSH_PRIVATE_KEY_PATH'], './playbooks/templates/id_rsa')
  FileUtils.cp(ENV['GITCONFIG_PATH'], './playbooks/templates/.gitconfig')

  # Run Ansible from the Vagrant VM: docker compose environments variables
  config.vm.provision 'ansible_local' do |ansible|
    ansible.groups = {
      'betterlists-vm' => ['default']
    }
    ansible.playbook = 'playbooks/docker_compose_env.yml'
  end

  # Run containers
  config.vm.provision :docker
  # https://github.com/leighmcculloch/vagrant-docker-compose
  config.vm.provision :docker_compose,
                      compose_version: '1.7.1',
                      yml: '/vagrant/containers/docker-compose.yml',
                      # don't rebuild if environment variable 'DOCKER_COMPOSE_REBUILD' is not set or
                      # if it is equal to 'false' (environment variables return a string)
                      rebuild: !ENV['DOCKER_COMPOSE_REBUILD'].nil? &&
                        ENV['DOCKER_COMPOSE_REBUILD'].strip.downcase != 'false',
                      run: 'always'

  # Run Ansible from the Vagrant VM: provisioning the hanami app
  # patch: if 'install rvm' tasks and 'setup rvm' tasks run in the same playbook provisioning block
  #   'rvm not found' error is raised
  config.vm.provision 'ansible_local' do |ansible|
    ansible.groups = {
      'betterlists-vm' => ['default']
    }
    ansible.playbook = 'playbooks/rvm_install.yml'
  end
  #
  config.vm.provision 'ansible_local' do |ansible|
    ansible.groups = {
      'betterlists-vm' => ['default']
    }
    ansible.playbook = 'playbooks/master.yml'
  end
end
