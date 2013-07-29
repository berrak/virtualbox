##
## This class manage hosts
## 
class vb_hosts::config {
		
	$vaddress = $::ipaddress
	$vhostname = $::hostname
	$vdomain = $::domain	

		
	# Create a subdirectory for Apache2 virtual host url name resolution
	
	file { "/etc/vhosts.d":
		ensure => "directory",
		owner => 'root',
		group => 'root',
	}
	
    file { "/etc/hosts" :
        content => template( "vb_hosts/hosts.erb" ),
          owner => 'root',
          group => 'root',
		require => File["/etc/vhosts.d"],
    }

}
