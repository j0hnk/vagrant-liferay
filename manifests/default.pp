# Basic Puppet Apache manifest

class apt-get-update {
	exec { 'add-repos':
    		command => '/bin/cp -f /vagrant/sources.list /etc/apt/sources.list'
  	}
	exec { 'apt-get update':
		command => '/usr/bin/apt-get update'
  	}
}

class openjdk-6-jdk {
	package { "openjdk-6-jdk":
		ensure => present,
	}
}

class unzip {
	package { "unzip":
    		ensure => present,
  	}
}

include apt-get-update
include unzip
include openjdk-6-jdk
