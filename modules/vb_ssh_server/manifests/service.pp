##
## Puppet manage openssh server
##
class vb_ssh_server::service {
    
	service { "ssh":
		
			ensure => running,
		 hasstatus => true,
		hasrestart => true,
			enable => true,
		   require => Package["openssh-server"],

	}
	
}