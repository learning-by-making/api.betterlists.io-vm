# -*- mode: ruby -*-
# vi: set ft=ruby :

$install_ansible = <<SCRIPT
apt-get -y install software-properties-common
apt-add-repository ppa:ansible/ansible
apt-get -y update
apt-get -y install ansible

SCRIPT

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # enable the plugin https://github.com/gosuri/vagrant-env
  # config.env.enable
  config.env.load('.env.local', '.env')

  config.vm.hostname = ENV['APP_NAME']

  config.vm.box = 'ubuntu/trusty64'
  # the default user for this box is 'vagrant'
  # config.ssh.username = ENV['VM_USERNAME']

  # https://www.vagrantup.com/docs/synced-folders/
  config.vm.synced_folder ENV['SOURCE_HOST_FOLDER'], "/home/#{ENV['VM_USERNAME']}/#{ENV['APP_NAME']}", create: true

  FileUtils.cp(ENV['SSH_PRIVATE_KEY_PATH'], './templates/id_rsa')

  # http://stackoverflow.com/a/35304194
  config.vm.provision 'shell', inline: $install_ansible
  # Patch for https://github.com/mitchellh/vagrant/issues/6793
  config.vm.provision 'shell' do |s|
    s.inline = '[[ ! -f $1 ]] || grep -F -q "$2" $1 || sed -i "/__main__/a \\    $2" $1'
    s.args = ['/usr/bin/ansible-galaxy', "if sys.argv == ['/usr/bin/ansible-galaxy', '--help']: sys.argv.insert(1, 'info')"]
  end

  # Run Ansible from the Vagrant VM
  # patch: if 'install rvm' tasks and 'setup rvm' tasks run in the same playbook provisioning block
  #   'rvm not found' error is raised
  config.vm.provision 'ansible_local' do |ansible|
    ansible.groups = {
      'api-betterlists-io' => ['default']
    }
    ansible.playbook = 'rvm_install.yml'
  end
  #
  config.vm.provision 'ansible_local' do |ansible|
    ansible.groups = {
      'api-betterlists-io' => ['default']
    }
    ansible.playbook = 'playbook.yml'
  end

  # Run containers
  config.vm.provision :docker
  # https://github.com/leighmcculloch/vagrant-docker-compose
  config.vm.provision :docker_compose,
                      yml: '/vagrant/docker-compose.yml',
                      # don't rebuild if environment variable 'DOCKER_COMPOSE_REBUILD' is not set or
                      # if it is equal to 'false' (environment variables return a string)
                      rebuild: !ENV['DOCKER_COMPOSE_REBUILD'].nil? &&
                        ENV['DOCKER_COMPOSE_REBUILD'].strip.downcase != 'false',
                      run: 'always'
end
