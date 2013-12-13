##
## This define manage the settings in hosts file
# Sample usage:
#
#     vb_hosts::config {
#        apache_virtual_host => [ "www.vbox.tld", "jensen.vbox.tld"  ]
#     }  
##
##
define vb_hosts::config ( $apache_virtual_host = '' ) {

	$myaddress = $::ipaddress
	$myhostname = $::hostname
	$mydomain = $::domain
		
	# copy the array
	
	if $apache_virtual_host != '' {
        $vhostfqdn = $apache_virtual_host
    }


    file { "/etc/hosts" :
        content => template( "vb_hosts/hosts.erb" ),
          owner => 'root',
          group => 'root',
    }	
	
}
