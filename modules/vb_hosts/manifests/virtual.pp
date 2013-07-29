##
## Manage the hosts file
## 
class vb_hosts::virtual inherits vb_hosts {
			
	$myaddress = $::ipaddress
	$myhostname = $::hostname
	$mydomain = $::domain
	
    $teststring = 'This is inherited!'

    File ["/etc/hosts"] {
        content => template( "vb_hosts/hosts.erb" ),
          owner => 'root',
          group => 'root',
    }

}
