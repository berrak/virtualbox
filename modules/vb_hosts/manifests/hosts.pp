##
## This defines the hosts file
## 
define vb_hosts::hosts {
			
	$myaddress = $::ipaddress
	$myhostname = $::hostname
	$mydomain = $::domain
	
	$myfqdn = $name
	
	$teststring = 'This is a test'
	
    file { "/etc/hosts" :
        content => template( "vb_hosts/hosts.erb" ),
          owner => 'root',
          group => 'root',
    }

}
