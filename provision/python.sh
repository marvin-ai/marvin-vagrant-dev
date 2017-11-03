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
echo ' INSTALLING PYTHON VIRTUALENVWRAPPER'
echo '----------------------------------------------'

sudo apt-get -qy install python2.7-dev python-pip ipython
sudo apt-get -qy install libffi-dev
sudo apt-get -qy install libssl-dev
sudo apt-get -qy install libxml2-dev libxslt1-dev
sudo apt-get -qy install libpng12-dev libfreetype6-dev
sudo apt-get -qy install python-tk

pip install -q virtualenvwrapper

echo 'export WORKON_HOME=/home/vagrant/.virtualenvs' >> /home/vagrant/.profile
echo 'source /usr/local/bin/virtualenvwrapper.sh' >> /home/vagrant/.profile

