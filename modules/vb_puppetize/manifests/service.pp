##
## Puppet service.
##
class vb_puppetize::service {

    # Reloads puppet agent. Debian default (/etc/default/puppet) ensures
    # agent is NOT running. If this is not wanted, configure that file.
    # and replace 'ensure => stopped' below, with 'ensure => running'
    
    service { "halt_puppet_agent":
                  name => puppet,
	    hasrestart => true,
                enable => false,
                ensure => stopped,
	       require => Class["vb_puppetize::install"],
    }

    # Note: in a virtual setup, puppet master and agent always runs on same vhost
    # Thus no need to test if this is a master or node, just restart service.
	
	service { "puppetmaster":
	hasrestart => true,
			enable => true,
			ensure => running,
		   require => Class["vb_puppetize::install"],
	}
    

}