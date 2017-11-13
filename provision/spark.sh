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
echo ' INSTALLING SPARK'
echo '----------------------------------------------'

cd /tmp
echo "Getting spark binaries..."
wget http://archive.apache.org/dist/spark/spark-2.1.1/spark-2.1.1-bin-hadoop2.6.tgz -q
tar -xf spark-2.1.1-bin-hadoop2.6.tgz
sudo rm -f spark-2.1.1-bin-hadoop2.6.tgz

sudo mv -f spark-2.1.1-bin-hadoop2.6 /opt/spark

cp -f /tmp/hadoop-files/yarn-site.xml /opt/spark/conf/yarn-site.xml
cp -f /tmp/hadoop-files/hdfs-site.xml /opt/spark/conf/hdfs-site.xml
cp -f /tmp/hadoop-files/core-site.xml /opt/spark/conf/core-site.xml
cp -f /tmp/hadoop-files/hive-site.xml /opt/spark/conf/hive-site.xml

if [[ $(hostname -s) = 'marvin-hadoop' ]]; then
	echo "export SPARK_HOME=/opt/spark" >> /home/vagrant/.profile
	echo "export JAVA_HOME=/usr/lib/jvm/java-7-oracle-cloudera" >> /home/vagrant/.profile
	echo 'PATH="$JAVA_HOME/bin:$SPARK_HOME/bin:$PATH"' >> /home/vagrant/.profile

	source /home/vagrant/.profile

	echo "spark.master yarn" | sudo tee --append /opt/spark/conf/spark-defaults.conf
	echo "spark.driver.memory 512m" | sudo tee --append /opt/spark/conf/spark-defaults.conf
	echo "spark.yarn.am.memory 512m" | sudo tee --append /opt/spark/conf/spark-defaults.conf
	echo "spark.yarn.submit.file.replication 1" | sudo tee --append /opt/spark/conf/spark-defaults.conf
	echo "spark.yarn.queue root.marvin" | sudo tee --append /opt/spark/conf/spark-defaults.conf
	

	echo "HADOOP_CONF_DIR=/etc/hadoop/conf" | sudo tee --append /opt/spark/conf/spark-env.sh
	echo "SPARK_LOCAL_IP='10.0.0.11'" | sudo tee --append /opt/spark/conf/spark-env.sh
fi

if [[ $(hostname -s) = 'marvin-dev' ]]; then
	echo "export SPARK_HOME=/opt/spark" >> /home/vagrant/.profile
	echo 'PATH="$SPARK_HOME/bin:$PATH"' >> /home/vagrant/.profile

	echo "spark.master yarn" | sudo tee --append /opt/spark/conf/spark-defaults.conf
	echo "spark.driver.memory 512m" | sudo tee --append /opt/spark/conf/spark-defaults.conf
	echo "spark.yarn.am.memory 512m" | sudo tee --append /opt/spark/conf/spark-defaults.conf
	echo "spark.yarn.submit.file.replication 1" | sudo tee --append /opt/spark/conf/spark-defaults.conf
	echo "spark.yarn.queue root.marvin" | sudo tee --append /opt/spark/conf/spark-defaults.conf

	echo "HADOOP_CONF_DIR=/opt/spark/conf" | sudo tee --append /opt/spark/conf/spark-env.sh
	echo "SPARK_LOCAL_IP='10.0.0.10'" | sudo tee --append /opt/spark/conf/spark-env.sh

	source /home/vagrant/.profile
fi

$SPARK_HOME/bin/spark-shell --version