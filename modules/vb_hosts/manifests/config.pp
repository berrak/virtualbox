##
## This class manage the settings in hosts file
##
class vb_hosts::config ( $apache_virtual_host = undef ) {

	$myaddress = $::ipaddress
	$myhostname = $::hostname
	$mydomain = $::domain
	
	notify { "$apache_virtual_host" : }
	
	# copy the array
	if $apache_virtual_host != undef {
        $vhostfqdn = $apache_virtual_host
    } else
	{
	    $vhostfqdn = ''
		$apache_virtual_host = ''
	}

    $hostip = $::ipaddress 

    file { "/etc/hosts" :
        content => template( "vb_hosts/hosts.erb" ),
          owner => 'root',
          group => 'root',
    }	
	
}
