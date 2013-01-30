# Liferay Puppet Apache manifest


class liferay {
	$liferay_folder="/opt/liferay-portal"
	$liferay_version="6.1.1-ce-ga2"
	$liferay_archive="liferay-portal-${liferay_version}-20120731132656558.zip"
	$tomcat_version="7.0.27"

	Exec { path => "/bin:/usr/bin" }


	file { ["/vagrant/liferay","/vagrant/liferay/deploy","${liferay_folder}"]:
		ensure => directory,
		owner  => vagrant,
		group  => vagrant,
	}
	
	# ZIP file deployment (two steps), first unzip in /tmp then move data to /opt
	exec { "unzip":
		require	=> [File["${liferay_folder}"], Class["unzip"]],
		command => "unzip -qq /vagrant/${liferay_archive} -d /tmp/",
		creates	=> "/tmp/liferay-portal-${liferay_version}/data",
		unless	=> "test -d ${liferay_folder}/data",
		user	=> vagrant
	}
	exec { "deploy":
		require => Exec["unzip"],
		command	=> "mv /tmp/liferay-portal-${liferay_version}/* ${liferay_folder}/",
		creates	=> "${liferay_folder}/data",
		user	=> vagrant
	}

	# symlink tomcat-VERSION to tomcat, make init script easier to maintain
	file { "${liferay_folder}/tomcat": 
		require	=> Exec["deploy"],
		ensure	=> link,
		target	=> "${liferay_folder}/tomcat-${tomcat_version}",
		owner	=> vagrant,
		group	=> vagrant
	}
	
	# copy portal-ext.properties
	file { "${liferay_folder}/portal-ext.properties":
		require => Exec["deploy"],
		ensure	=> present,
		source	=> "/vagrant/portal-ext.properties",
		owner	=> vagrant,
		group	=> vagrant,
		mode	=> 655
	}
	
	# install init script
	file { "/etc/init.d/liferay":
		ensure	=> present,
		source	=> "/vagrant/liferay-init",
		owner	=> root,
		group	=> root,
		mode	=> 755
	}
	
	# add liferay service to startup and start it
	service { "liferay":
		require	=> [File["/etc/init.d/liferay"], File["${liferay_folder}/tomcat"], File["$liferay_folder/portal-ext.properties"]],
		enable	=> true,
		hasstatus => true,
		ensure  => running
	}	
}

class apt-get-update {
	exec { "add-repos":
    		command => "/bin/cp -f /vagrant/sources.list /etc/apt/sources.list"
  	}
	exec { "apt-get update":
		command => "/usr/bin/apt-get update",
		require	=> Exec["add-repos"]
  	}
}

class openjdk-6-jdk {
	package { "openjdk-6-jdk":
		ensure => present,
		require => Class["apt-get-update"]
	}
}

class unzip {
	package { "unzip":
    		ensure => present,
		require => Class["apt-get-update"]
  	}
}

include apt-get-update
include unzip
include openjdk-6-jdk
include liferay
