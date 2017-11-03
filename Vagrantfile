# -*- mode: ruby -*-
# vi: set ft=ruby :

# Copyright [2017] [B2W Digital]
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

HADOOP_BOX_VERSION="0.0.2"
DEV_BOX_VERSION="0.0.2"
CORE_BOX_VERSION="0.0.2"
UBUNTU_BOX_VERSION="20171030.0.0"

#------------------------Handling with envs
rebuild_core=(ENV['REBUILD_CORE'] || 'false').downcase
rebuild_dev=(ENV['REBUILD_DEV'] || 'false').downcase
rebuild_hadoop=(ENV['REBUILD_HADOOP'] || 'false').downcase
#-------------------------------------------------

Vagrant.require_version ">= 1.9.2"

Vagrant.configure("2") do |config|

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--cpus", 2]
  end

  config.ssh.password = "vagrant"

  # --------------------------------------------
  # Core Machine Definition
  # --------------------------------------------
  config.vm.define "core", autostart: false do |core|
    
    core.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", 1024]
    end

    if rebuild_core == 'true'
      core.vm.box = "ubuntu/trusty64"
      core.vm.box_version = UBUNTU_BOX_VERSION

      # Welcome
      core.vm.provision :shell, :path => "provision/welcome.sh"

      # install common stuffs
      core.vm.provision :shell, :inline => "apt-get -y update && apt-get -y upgrade"
      core.vm.provision :shell, :inline => "apt-get install --reinstall -y language-pack-en language-pack-pt"
      core.vm.provision :shell, :inline => "apt-get install -y curl vim htop unzip"
      core.vm.provision :shell, :inline => "apt-get install -y rsync ssh"

      # clean
      core.vm.provision "clean", type: "shell", path: "provision/clean.sh"
    end
  end

  
  # --------------------------------------------
  # Hadoop Ecosystem Machine Definition
  # --------------------------------------------
  config.vm.define "hadoop", autostart: false do |hadoop|

    hadoop.vm.network :private_network, ip: "10.0.0.11"
    hadoop.vm.hostname = "marvin-hadoop"

    hadoop.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", 5120]
    end

    if rebuild_hadoop == 'true'

      hadoop.vm.box = "marvin-ai/marvin-platform-core"
      hadoop.vm.box_version = CORE_BOX_VERSION
      
      # copy file
      hadoop.vm.provision "hadoopfile", type:"file", source: "provision/general_files", destination: "/tmp/hadoop-files"

      # remove and add host entry
      hadoop.vm.provision "hpp", type: "shell", path: "provision/update-hosts.sh", :args => "prepare marvin-hadoop 10.0.0.11"
      hadoop.vm.provision "hadd", type: "shell", path: "provision/update-hosts.sh", :args => "add marvin-dev 10.0.0.10"

      # Hadoop and folks
      hadoop.vm.provision "hadoop", type: "shell", path: "provision/cdh.sh"

      # Hive procedure
      hadoop.vm.provision "hive", type: "shell", path: "provision/hive.sh"

      # MySql procedure
      hadoop.vm.provision "mysql", type: "shell", path: "provision/mysql.sh"

      # spark provision
      hadoop.vm.provision "spark", type: "shell", path: "provision/spark.sh"

      # clean
      hadoop.vm.provision "clean", type: "shell", path: "provision/clean.sh"

    else
      hadoop.vm.box = "marvin-ai/marvin-platform-hadoop"
      hadoop.vm.box_version = HADOOP_BOX_VERSION
    end

    # Hadoop ports
    hadoop.vm.network "forwarded_port", guest: 50070, host: 50070 # UI NameNode
    hadoop.vm.network "forwarded_port", guest: 50030, host: 50030 # UI JobTracker
    hadoop.vm.network "forwarded_port", guest: 50060, host: 50060 # UI TaskTracker
    hadoop.vm.network "forwarded_port", guest: 8088, host: 8088 # Hadoop Aplications
    hadoop.vm.network "forwarded_port", guest: 8042, host: 8042 # Hadoop X
    hadoop.vm.network "forwarded_port", guest: 10000, host: 10000 # Hive
    hadoop.vm.network "forwarded_port", guest: 8020, host: 8020 # HDFS
    hadoop.vm.network "forwarded_port", guest: 7077, host: 7077 # Spark Master Server
    hadoop.vm.network "forwarded_port", guest: 8080, host: 8080 # Spark Web UI
    hadoop.vm.network "forwarded_port", guest: 4040, host: 4040 # Spark Context Web UI
    hadoop.vm.network "forwarded_port", guest: 19888, host: 19888 # Hadoop Logs
  end


  # --------------------------------------------
  # Development Machine Definition
  # --------------------------------------------
  config.vm.define "dev", primary: true do |dev|

    dev.vm.network :private_network, ip: "10.0.0.10"
    dev.vm.hostname = "marvin-dev"

    dev.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", 2048]
    end

    if rebuild_dev == 'true'

      dev.vm.box = "marvin-ai/marvin-platform-core"
      dev.vm.box_version = CORE_BOX_VERSION
      
      dev.vm.provision :shell, :inline => "apt-get -qy install build-essential liblapack-dev libblas-dev libjpeg8-dev graphviz libsasl2-dev"

      # copy file
      dev.vm.provision "hadoopfile", type:"file", source: "provision/general_files", destination: "/tmp/hadoop-files"

      # remove and add host entry
      dev.vm.provision "hpp", type: "shell", path: "provision/update-hosts.sh", :args => "prepare marvin-dev 10.0.0.10"
      dev.vm.provision "hadd", type: "shell", path: "provision/update-hosts.sh", :args => "add marvin-hadoop 10.0.0.11"

      # Git
      dev.vm.provision "git", type: "shell", path: "provision/git.sh"

      # Ruby
      dev.vm.provision "rvm", type: "shell", path: "provision/rvm.sh", :args => "head"
      dev.vm.provision "ruby", type: "shell", path: "provision/ruby.sh", :args => "2.3.1 bundler"

      # Python
      dev.vm.provision "python", type: "shell", path: "provision/python.sh"

      # Java
      dev.vm.provision "java", type: "shell", path: "provision/java.sh"

      # Scala
      dev.vm.provision "scala", type: "shell", path: "provision/scala.sh"

      # R
      dev.vm.provision "r", type: "shell", path: "provision/R.sh"

      # Marvin Data
      dev.vm.provision "marvinenv", type: "shell", path: "provision/marvin_env.sh"

      # Prepare first time
      dev.vm.provision "prepare", type: "shell", path: "provision/prepare_first_time.sh"

      # spark client
      dev.vm.provision "spark", type: "shell", path: "provision/spark.sh"

      # clean
      dev.vm.provision "clean", type: "shell", path: "provision/clean.sh"

    else
      dev.vm.box = "marvin-ai/marvin-platform-dev"
      dev.vm.box_version = DEV_BOX_VERSION
    end

    #-----------------Network
    # Jupyter ports
    dev.vm.network :forwarded_port, guest: 8888, host: 8888, host_ip:"127.0.0.1"
    dev.vm.network :forwarded_port, guest: 8889, host: 8889, host_ip:"127.0.0.1"
    dev.vm.network :forwarded_port, guest: 8890, host: 8890, host_ip:"127.0.0.1"

    # RStudio Server
    dev.vm.network :forwarded_port, guest: 8787, host: 8787, host_ip:"127.0.0.1"

    # Elastic Search
    dev.vm.network :forwarded_port, guest: 9200, host: 9200, host_ip:"127.0.0.1"

    # Engine Executor API
    dev.vm.network :forwarded_port, guest: 8000, host: 8000, host_ip:"127.0.0.1"

    # Engine Server
    dev.vm.network :forwarded_port, guest: 50051, host: 50051, host_ip:"0.0.0.0"
    dev.vm.network :forwarded_port, guest: 50052, host: 50052, host_ip:"0.0.0.0"
    dev.vm.network :forwarded_port, guest: 50053, host: 50053, host_ip:"0.0.0.0"
    dev.vm.network :forwarded_port, guest: 50054, host: 50054, host_ip:"0.0.0.0"
    dev.vm.network :forwarded_port, guest: 50055, host: 50055, host_ip:"0.0.0.0"
  end
end
