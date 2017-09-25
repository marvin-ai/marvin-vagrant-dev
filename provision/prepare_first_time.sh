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

# adds first time script to bashrc
echo 'export rvm_trust_rvmrcs_flag=1 && cd /vagrant && bundle install && ruby /vagrant/provision/first_time.rb && cd ~ && ls' >> /home/vagrant/.bashrc
echo 'export LC_CTYPE=en_US.UTF-8' >> /home/vagrant/.bashrc
echo 'export LC_ALL=en_US.UTF-8' >> /home/vagrant/.bashrc