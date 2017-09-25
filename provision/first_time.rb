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

require 'colorize'
require 'git'
require 'fileutils'

puts 'Welcome to Marvin Development Toolbox'.yellow

puts 'Do you want to configure private GIT access??? (yes|no)'
resp = gets.chomp

if ['y', 'yes', 'sim', 'vai'].include? resp.downcase then
	# config git users
	puts 'Lets start configuring your git user'

	puts 'Please enter your git user name:'.light_blue
	git_user_name = gets.chomp

	puts 'Please enter your git user email:'.light_blue
	git_user_email = gets.chomp

	system("git config --global user.name \"#{git_user_name}\"")
	system("git config --global user.email \"#{git_user_email}\"")

	puts 'Generating ssh keys..'
	
	system 'mkdir ~/.ssh'
	system 'ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa'

	puts 'ssh key generated successfully'

	puts ''
	puts '**********************************************************************************************'
	puts 'ATENTION!!!'
	puts 'Add this key on your **Git** ssh keys'
	puts 'This is needed for simplify the interaction with git private repositories'
	puts '**********************************************************************************************'
	puts ''
	puts File.read('/home/vagrant/.ssh/id_rsa.pub').light_blue
	puts ''
	puts 'press enter to continue...'
	gets
end

require_relative 'projects'

# generating environment links
puts 'Generating environment symbolic links'
system "mkdir -p /vagrant/projects/.envs" 
system "sudo ln -fsv /usr/share/scala /vagrant/projects/.envs/scala-env"
system "sudo ln -fsv /usr/lib/jvm/java-8-oracle /vagrant/projects/.envs/java-env"

# removes script form bashrc
system "sed -i '/.*first_time.rb/d' ~/.bashrc"

# add foreman
system 'sudo gem install foreman'

puts 'You are now ready to use the development box!'
puts 'press enter to continue...'
gets

Dir.chdir '/home/vagrant'
system 'clear'
system 'ls'
