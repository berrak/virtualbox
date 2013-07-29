##
## Manage the hosts file
## 
class vb_hosts::config::virtual inherits vb_hosts::config {
			
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
