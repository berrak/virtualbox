##
## This class manage hosts
## 
class vb_hosts::config ( $puppetserver_hostname = '' ) {
		
	
	$vhostname = $::hostname 
	
	if $vhostname == $puppetserver_hostname {
    
        file { "/etc/hosts" :
		   content => template( "vb_hosts/hosts.erb" ),
             owner => 'root',
             group => 'root',
        }
		
    }    
    else {
        fail("FAIL: Given hostname ${puppetserver_hostname} unknown. Aborting...")
    }
       
	
}
