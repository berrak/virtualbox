##
## Puppet configuration
##
class vb_puppetize::config {


    # Note: in a virtual setup, puppet master and agent always runs on same vhost
    # Thus no need to test if this is a master or node, just copy files to vhost.
    
    $vhostname = $::hostname
    $vdomain = $::domain
    
    file { "/etc/puppet/puppet.conf" :
        ensure => present,
       content => template( "vb_puppetize/puppet.conf.erb" ),
        owner => 'root',
        group => 'root',
        require => Class["vb_puppetize::install"],
        notify => Class["vb_puppetize::service"],
    }
    
    file { "/etc/puppet/auth.conf" :
        ensure => present,
        source => "puppet:///modules/vb_puppetize/auth.conf",
        owner => 'root',
        group => 'root',
        require => Class["vb_puppetize::install"],
        notify => Class["vb_puppetize::service"],
    }
    
    file { "/etc/puppet/fileserver.conf" :
        ensure => present,
        source => "puppet:///modules/vb_puppetize/fileserver.conf",
        owner => 'root',
        group => 'root',
        require => Class["vb_puppetize::install"],
        notify => Class["vb_puppetize::service"],
    }
    
    # create the directory matching the path in fileserver.conf
	file { "/etc/puppet/files":
		ensure => "directory",
		owner => 'root',
		group => 'root',
	}
    
    # sets e.g. if puppet master runs as daemon or not 
    
    file { "/etc/default/puppetmaster" :
        ensure => present,
        source => "puppet:///modules/vb_puppetize/puppetmaster",
        owner => 'root',
        group => 'root',
        require => Class["vb_puppetize::install"],
        notify => Class["vb_puppetize::service"],
    }
    
    
    # Agent set up.
    # Sets e.g. if agent runs as daemon or not 

    file { "/etc/default/puppet" :
        ensure => present,
        source => "puppet:///modules/vb_puppetize/puppet",
        owner => 'root',
        group => 'root',
        require => Class["vb_puppetize::install"],
        notify => Class["vb_puppetize::service"],
    }


}