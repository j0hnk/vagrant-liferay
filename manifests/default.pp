# Basic Puppet Apache manifest

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

class liferay {
  user { "liferay":
    ensure => 'present',
  }
}

include unzip
include openjdk-6-jdk
include liferay
