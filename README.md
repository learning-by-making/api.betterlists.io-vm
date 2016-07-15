# betterlists.io-vm

provision a development environment to [api.betterlists.io](https://github.com/learning-by-making/api.betterlists.io) projects through tools like docker, ansible and vagrant (with some vagrant plugins)

Requirements:
* Git
* Virtualbox
* Vagrant

## start development environment

```bash
$ mkdir betterlists.io
$ cd betterlists.io
$ git clone git@github.com:learning-by-making/betterlists.io-vm.git vm
$ cd vm
$ vagrant up
```

among other things on vagrant up provisioning:
* fetch the repo 
* install gems
* configure the db connection in your local .env.development file 
* run migrations

you can SSH into the vm with ```$ vagrant ssh```

(on the guest vm) the roots folder of [api.betterlists.io](https://github.com/learning-by-making/api.betterlists.io) projects is ```~/api.betterlists.io``` 

from the inside of this folder you can run commands like

```bash
$ hanami db migrate
$ rspec
$ passenger start
$ git st
$ git flow feature start new_feature
```

on your host machine inside the ```betterlists.io``` folder now you have the ```api``` folder that is synchronized with the folder ```~/api.betterlists.io``` of the guest vm.

you can edit source code with your favorite editor from your local host (or from the guest vm if you prefer).

you can manage repository (with git flow) from your local host or from the guest vm (your ssh key has copied into the guest vm).

### environment variables

.env file contains environment variables. if you want you can override them creating and editing .env.local file.
* DOCKER_COMPOSE_REBUILD
* VM_USERNAME
* APP_NAME
* SOURCE_HOST_FOLDER
* RUBY_VERSION
* SSH_PRIVATE_KEY_PATH
* SSH_PASSPHRASE
* GITCONFIG_PATH
* VM_MEMORY
* WEB_HOST_PORT
* WEB_GUEST_PORT
* POSTGRES_VERSION
* POSTGRES_USER
* POSTGRES_PASSWORD
* POSTGRES_HOST_PORT

### run psql

#### from guest mv
```bash
$ psql -U <POSTGRES_USER> -h 127.0.0.1
```

#### from container
```bash
$ docker run -it --rm --net containers_default --link containers_postgres_1:postgres postgres:<POSTGRES_VERSION> psql -h postgres -U <POSTGRES_USER>
```

#### from [api.betterlists.io](https://github.com/learning-by-making/api.betterlists.io) projects
```bash
$ hanami db console
```

## stop development environment

you can shutdown guest vm with ```$ vagrant halt``` and reprise developing with ```$ vagrant up```.
db data persist on the guest vm as well as your repo changes that aren't pushed to remote.
however if you run ```vagrant destroy``` you lose db data (but not your repo changes that aren't pushed to remote because it's synced with your local host).
