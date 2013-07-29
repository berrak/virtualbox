##
## This defines the hosts file
## 
define vb_hosts::hosts {
			
	$myaddress = $::ipaddress
	$myhostname = $::hostname
	$mydomain = $::domain
	
	# this is the default usage
	if $name == $::fqdn {
	    $myfqdn = $name
	}
	
	# this when adding virtual host to Apache
	if $name != $::fqdn {
	
	    $myfqdn = $::fqdn
		
	    $apachevfqdn = $name
		
	}
	
    file { "/etc/hosts" :
        content => template( "vb_hosts/hosts.erb" ),
          owner => 'root',
          group => 'root',
    }

}
