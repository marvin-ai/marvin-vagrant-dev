#Marvin Vagrant Development Box

##Bootstrap


- install [vagrant](http://www.vagrantup.com) and [virtual box](http://www.virtualbox.org);


```
# clone repo

git clone https://github.com/marvin-ai/marvin-vagrant-dev.git

# start provision
cd marvin-vagrant-dev

vagrant up dev

or

vagrant up hadoop

# wait for instalation process
vagrant ssh dev

or 

vagrant ssh hadoop

# follow interactive configuration script
```

The marvin source projects will be on your home folder, to compile and use the marvin toolbox type:


```
# firt steps

workon python-toolbox-env

make marvin

marvin --help

```
