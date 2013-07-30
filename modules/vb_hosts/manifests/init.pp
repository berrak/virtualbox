##
## This define manage the settings in hosts file
##
define vb_hosts ( $apache_virtual_host = '') {

	$myaddress = $::ipaddress
	$myhostname = $::hostname
	$mydomain = $::domain
	
	if $apache_virtual_host != '' {
        $vhostfqdn = "$::ipaddress  $apache_virtual_host"
    } else
	{
	    $vhostfqdn = ''
	}

    file { "/etc/hosts" :
        content => template( "vb_hosts/hosts.erb" ),
          owner => 'root',
          group => 'root',
    }	
	
}
