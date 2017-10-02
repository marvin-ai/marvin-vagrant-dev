# Marvin Vagrant Development Box

## Bootstrap

### install requirements
- [vagrant](http://www.vagrantup.com)
- [virtual box](http://www.virtualbox.org)

### clone repo and start provision
```shell
git clone https://github.com/marvin-ai/marvin-vagrant-dev.git
cd marvin-vagrant-dev
```
### to prepare dev (engine creation) box
```shell
vagrant up dev
vagrant ssh dev
```
Wait for provision process and follow interactive configuration script after access the dev box using vagrant ssh command.

The marvin source projects will be on your home folder, to compile and use the marvin toolbox type:

```shell
workon python-toolbox-env
make marvin
marvin --help
```
### create a new marvin engine
To create a new engine type:
```shell
workon python-toolbox-env
marvin engine-generate
```
respond the interactive prompt and wait for the engine environment preparation...

```shell
workon <new_engine_name>-env
marvin --help
```
and have fun :-)

### prepare hadoop (hadoop ecosystem) box
```shell
vagrant up hadoop
vagrant ssh hadoop
```


> Marvin is a project started at B2W Digital offices and released open source on September 2017.
