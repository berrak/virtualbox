##
## Manage Puppet
##
class vb_puppetize::install {


    # Note: in a virtual setup, puppet master and agent always runs on same vhost
    # Thus no need to test if this is a master or node, just copy files to vhost.
	
	
    # Debian defaults to install puppet-common which
    # depends on facter - but just to show both.
  
    package { [ "puppet", "facter" ] :
        ensure => present,
    }
	
    # install some puppet utilities for root
    
    file { "/root/bin" :
        ensure => directory,
         owner => 'root',
         group => 'root',
          mode => '0700',
    }
    
    file { "/root/bin/puppet.exec":
	     source => "puppet:///modules/puppetize/puppet.exec",
	      owner => 'root',
	      group => 'root',
	       mode => '0700',
		require => File["/root/bin"],
    }
    
    file { "/root/bin/puppet.simulate":
	    source => "puppet:///modules/puppetize/puppet.simulate",
	     owner => 'root',
	     group => 'root',
	      mode => '0700',
	   require => File["/root/bin"],
    }
	
  
    # For puppet server
    
    if $::fqdn == $::vb_puppetize::params::mypuppetserver_fqdn {
    
	package { "puppetmaster" :
	    ensure => present,
	}
	    
    }

}