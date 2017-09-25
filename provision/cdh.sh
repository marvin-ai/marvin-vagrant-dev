#!/usr/bin/env bash

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

echo '----------------------------------------------'
echo ' INSTALLING CDH'
echo '----------------------------------------------'

#####
# Instructions here
#
# https://www.cloudera.com/documentation/enterprise/5-6-x/topics/cdh_qs_yarn_pseudo.html
#
#####

sudo wget -qO - http://archive.cloudera.com/cm5/ubuntu/trusty/amd64/cm/archive.key | sudo apt-key add -
sudo wget -O /etc/apt/sources.list.d/cloudera-manager.list https://archive.cloudera.com/cm5/ubuntu/trusty/amd64/cm/cloudera.list

sudo wget https://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/archive.key -O archive.key | sudo apt-key add -
sudo wget 'https://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/cloudera.list' \ -O /etc/apt/sources.list.d/cloudera.list

sudo wget https://archive.cloudera.com/cdh5/one-click-install/trusty/amd64/cdh5-repository_1.0_all.deb
sudo dpkg -i cdh5-repository_1.0_all.deb

sudo apt-get update

sudo apt-get install -y oracle-j2sdk1.7

sudo apt-get install -y hadoop-conf-pseudo

sudo dpkg -L hadoop-conf-pseudo

sudo -u hdfs hdfs namenode -format
sudo /usr/lib/hadoop/libexec/init-hdfs.sh

cp -f /tmp/hadoop-files/yarn-site.xml /etc/hadoop/conf/yarn-site.xml
cp -f /tmp/hadoop-files/hdfs-site.xml /etc/hadoop/conf/hdfs-site.xml
cp -f /tmp/hadoop-files/core-site.xml /etc/hadoop/conf/core-site.xml
cp -f /tmp/hadoop-files/mapred-site.xml /etc/hadoop/conf/mapred-site.xml

sudo -u hdfs hadoop fs -mkdir /user/$USER
sudo -u hdfs hadoop fs -chown $USER /user/$USER

sudo -u hdfs hadoop fs -chmod -R 777 /tmp

sudo update-rc.d hadoop-mapreduce-historyserver disable
sudo update-rc.d hadoop-hdfs-secondarynamenode disable

for x in `cd /etc/init.d ; ls hadoop-*` ; do sudo service $x restart ; done

hadoop version