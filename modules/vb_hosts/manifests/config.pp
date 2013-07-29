##
## This class manage hosts
## 
class vb_hosts::config {
		
	$vaddress = $::ipaddress
	$vhostname = $::hostname
	$vdomain = $::domain	
	
    file { "/etc/hosts" :
        content => template( "vb_hosts/hosts.erb" ),
          owner => 'root',
          group => 'root',
    }

}
