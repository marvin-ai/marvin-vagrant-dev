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
echo ' INSTALLING R STUDIO'
echo '----------------------------------------------'

echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" | sudo tee -a /etc/apt/sources.list.d/sbt.list
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -
sudo apt-get -qq update
sudo apt-get install -y r-base

sudo apt-get -y install libcurl4-gnutls-dev libxml2-dev libssl-dev

# some packages installations
sudo su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\""

# install R packages from github
# sudo su - -c "R -e \"devtools::install_github('daattali/shinyjs')\""

# R-Studio Server Instalation
cd /tmp
wget https://download2.rstudio.org/rstudio-server-1.0.136-amd64.deb
sudo dpkg -i rstudio-server-1.0.136-amd64.deb
cd ~