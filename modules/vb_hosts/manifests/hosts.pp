##
## This defines the hosts file
## 
define vb_hosts::hosts ( $apache_virtual_host = '' ) {
			
	$myaddress = $::ipaddress
	$myhostname = $::hostname
	$mydomain = $::domain
	
	$myfqdn = $name
	
    file { "/etc/hosts" :
        content => template( "vb_hosts/hosts.erb" ),
          owner => 'root',
          group => 'root',
    }

}
