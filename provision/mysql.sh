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
echo ' INSTALLING MYSQL For Hive MetaStore'
echo '----------------------------------------------'

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password vagrant'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password vagrant'

sudo apt-get -qy install mysql-server-5.6 > /dev/null 2>&1
sudo apt-get -qy install libmysql-java > /dev/null 2>&1

echo "Setting mysql metastore database ..."
cd /usr/lib/hive/scripts/metastore/upgrade/mysql/
mysql -u "root" "-pvagrant" -Bse "CREATE DATABASE metastore;"
mysql -u "root" "-pvagrant" -Bse "USE metastore;SOURCE hive-schema-1.1.0.mysql.sql;"
mysql -u "root" "-pvagrant" -Bse "USE metastore;CREATE USER 'hiveuser'@'%' IDENTIFIED BY 'hivepassword';"
mysql -u "root" "-pvagrant" -Bse "USE metastore;GRANT all on *.* to 'hiveuser'@10.0.0.10 identified by 'hivepassword';"
mysql -u "root" "-pvagrant" -Bse "USE metastore;GRANT all on *.* to 'hiveuser'@10.0.0.11 identified by 'hivepassword';"
mysql -u "root" "-pvagrant" -Bse "USE metastore;flush privileges;"

sudo ln -s /usr/share/java/mysql-connector-java.jar /usr/lib/hive/lib/mysql-connector-java.jar

sudo cp -f /tmp/hadoop-files/hive-site.xml /etc/hive/conf/hive-site.xml
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

sudo service mysql restart

for x in `cd /etc/init.d ; ls hive*` ; do sudo service $x restart ; done

mysql --version