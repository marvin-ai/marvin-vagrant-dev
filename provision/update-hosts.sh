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

# @author: Claus Witt
# http://clauswitt.com/319.html
# @updated Daniel Takabayashi

# Adding or Removing Items to hosts file
# Use -h flag for help

DEFAULT_IP=127.0.0.1
IP=${3:-$DEFAULT_IP}

case "$1" in
  add)
        sed -ie "\|^$IP $2\$|d" /etc/hosts
        echo "$IP $2"  >> /etc/hosts
        ;;
  remove)
        sed -ie "\|^$IP $2\$|d" /etc/hosts
        ;;
  prepare)
        sed -ie "/127.0.0.1[[:space:]]\+$2/d" /etc/hosts
        sed -ie "\|^$IP $2\$|d" /etc/hosts
        echo "$IP $2"  >> /etc/hosts
        ;;

  *)
        echo "Usage: "
        echo "hosts.sh [add|remove|prepare] [hostname] [ip]"
        echo 
        echo "Ip defaults to 127.0.0.1"
        echo "Examples:"
        echo "hosts.sh add testing.com"
        echo "hosts.sh remove testing.com 192.168.1.1"
         echo "hosts.sh prepare testing.com 192.168.1.1"
        exit 1
        ;;
esac

exit 0