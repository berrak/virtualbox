##
## Manage Puppet
##
class vb_puppetize::install {
  
    include vb_puppetize::params
  
    # Debian defaults to install puppet-common which
    # depends on facter - but just to show both.
  
    # Install puppet agent regardless if this is the puppet server or agent
  
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