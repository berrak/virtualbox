##
## This define manage the settings in hosts file
##
define vb_hosts {

	$myaddress = $::ipaddress
	$myhostname = $::hostname
	$mydomain = $::domain
	
    $teststring = ''

    file { "/etc/hosts" :
        content => template( "vb_hosts/hosts.erb" ),
          owner => 'root',
          group => 'root',
    }	
	
}
