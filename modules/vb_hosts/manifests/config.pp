##
## This define manage the settings in hosts file
#  The resource identifier (i.e. 'bekr' is not used here but $name is
#  required for all resources as an identifier by Puppet itself.
#  
# Sample usage:
#
#     vb_hosts::config { 'bekr' :
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
