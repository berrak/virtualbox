##
## Manage the hosts file
## 
class vb_hosts::hosts ( $apache_virtual_host = undef ) {
			
	$myaddress = $::ipaddress
	$myhostname = $::hostname
	$mydomain = $::domain
	
	
    file { "/etc/hosts" :
        content => template( "vb_hosts/hosts.erb" ),
          owner => 'root',
          group => 'root',
    }

}
