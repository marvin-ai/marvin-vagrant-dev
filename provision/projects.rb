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

puts 'Cloning marvin source repositories if necessary...'

[
  {name: 'python-toolbox', group: 'marvin', url: 'https://github.com/marvin-ai/marvin-python-toolbox.git'},
  {name: 'engine-executor', group: 'marvin', url: 'https://github.com/marvin-ai/marvin-engine-executor.git'}
  # {name: 'simple-product-classification-engine', group: 'samples', url: ''}
].each do |project_hash|

  if project_hash[:group]
    project = "#{project_hash[:group]}/#{project_hash[:name]}"
    system "mkdir -p ~/#{project_hash[:group]}"
  else
    project = project_hash[:name]
  end

  if File.directory?("/vagrant/projects/#{project}")
    puts "Repository #{project} already cloned!"
  else
    puts "cloning #{project}..."
    begin
      Git.clone(project_hash[:url], "/vagrant/projects/#{project}")
    rescue
      puts "error cloning #{project}!"
    end
  end

  system "ln -sfv /vagrant/projects/#{project} ~/#{project}"
  puts "Creating virtualenv #{project_hash[:name]}-env..."
  system "bash -c 'source /usr/local/bin/virtualenvwrapper.sh && mkvirtualenv -a ~/#{project} #{project_hash[:name]}-env &> /dev/null && cd ~/#{project} && setvirtualenvproject'"
  puts "\n"
end
