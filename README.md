# betterlists.io-vm

provision a development environment to [api.betterlists.io](https://github.com/learning-by-making/api.betterlists.io) projects through tools like docker, ansible and vagrant (with some vagrant plugins)

Requirements:
* Git
* Virtualbox
* Vagrant

## start development environment

on local host

```bash
$ mkdir betterlists.io
$ cd betterlists.io
$ git clone git@github.com:learning-by-making/betterlists.io-vm.git vm
$ cd vm
$ vagrant up
```

on vagrant up, among other things, the provisioning script:
* clone the [api.betterlists.io](https://github.com/learning-by-making/api.betterlists.io) repo (if not already present)
* install gems (on a rvm gemset)
* configure the db connection in your local ```.env.development``` file 
* create db (if not present)
* run migrations

### guest vm equipment

* git
* git-flow
* rvm
* postgresql

## development workflow

ssh into the vm with 
```bash
$ vagrant ssh
```
the roots folder of [api.betterlists.io](https://github.com/learning-by-making/api.betterlists.io) projects is ```~/api.betterlists.io```.
from this folder run commands like

```bash
$ hanami db migrate
$ rspec
$ passenger start
$ git st
$ git flow feature start new_feature
```

on host machine inside the ```betterlists.io``` folder now there is ```api``` folder that is synchronized with the folder ```~/api.betterlists.io``` of the guest vm.

edit source code with your favorite editor from local host (or from the guest vm if you prefer).

manage repository from the guest vm (your ssh private key has been copied into it) or from local host
(remember to add your public key to your GitHub account).

### run psql

#### from guest vm bash
```bash
$ psql -U <POSTGRES_USER/APP_DB_USER> -h 127.0.0.1 -p <POSTGRES_HOST_PORT>
```

#### from guest vm container
```bash
$ docker run -it --rm --net containers_default --link containers_postgres_1:postgres postgres:<POSTGRES_VERSION> psql -h postgres -p <POSTGRES_HOST_PORT> -U <POSTGRES_USER/APP_DB_USER>
```

#### from [api.betterlists.io](https://github.com/learning-by-making/api.betterlists.io) roots folder
```bash
$ hanami db console
```

## environment variables

```.env``` file contains environment variables.

* DOCKER_COMPOSE_REBUILD: when true rebuild docker-compose containers on vagrant up and on vagrant provision ([vagrant-docker-compose](https://github.com/leighmcculloch/vagrant-docker-compose))
* VM_USERNAME: username of the vagrant box ([vagrant boxes](https://www.vagrantup.com/docs/boxes.html))
* APP_NAME: name of the application that we're developing. used as gemset name, folder name, ecc...
* SOURCE_HOST_FOLDER: the path of the source of the application on your local host
* RUBY_VERSION: ruby version, must use [.versions.conf](https://rvm.io/workflow/projects#project-file-versionsconf) syntax
* SSH_PRIVATE_KEY_PATH: path of your private key
* SSH_PASSPHRASE: passphrase of your private key
* GITCONFIG_PATH: path of your ```.gitconfig``` file
* VM_MEMORY: amount of memory you want to give to the vm ([vagrant virtualbox configuration](https://www.vagrantup.com/docs/virtualbox/configuration.html))
* WEB_HOST_PORT: port number of your local host where WEB_GUEST_PORT is forwarded
* WEB_GUEST_PORT: port number of the guest vm that is forwarded to the WEB_HOST_PORT. this must be the port that web server you'll run listen no
* POSTGRES_VERSION: postgresql container version ([docker postgres container](https://hub.docker.com/_/postgres/))
* POSTGRES_USER: postgresql 'superuser' user ([docker postgres container](https://hub.docker.com/_/postgres/))
* POSTGRES_PASSWORD: postgresql 'superuser' password ([docker postgres container](https://hub.docker.com/_/postgres/))
* POSTGRES_HOST_PORT: port number of the guest vm where the postgresql container ports is exposed ([docker compose ports container](https://docs.docker.com/compose/compose-file/#/ports))
* APP_DB_USER: postgres user for the application 
* APP_DB_PASSWORD: postgres password for the application's user

### overriding

override them creating and editing ```.env.local``` file.
typically override is SSH_PRIVATE_KEY_PATH, SSH_PASSPHRASE, GITCONFIG_PATH, POSTGRES_PASSWORD and APP_DB_PASSWORD.
if the vm has already been created overriding variables that involve vm configuration on ```Vagrantfile``` (i.e. config.vm.* except provision) 
need to run ```vagrant reload --provision``` (or ```vagrant halt``` and ```vagrant up```). 
otherwise just run ```vagrant provision```.
overridding of POSTGRES_USER or POSTGRES_PASSWORD need to recreate the vm with ```vagrant destroy``` and ```vagrant up``` 
or set them manually via psql on the guest vm. 

### Syntax warning

inside .env* files docker doesn't like whitespaces around '='

## stop development environment

you can shutdown guest vm with ```$ vagrant halt``` and reprise developing with ```$ vagrant up```.
db data persist on the guest vm as well as your repo changes that aren't pushed to remote.
however if you run ```vagrant destroy``` you lose db data. 
differently local repo changes are kept because it's synced with your local host.
