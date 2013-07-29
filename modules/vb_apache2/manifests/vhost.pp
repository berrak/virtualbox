#
# Define new Apache2 virtual hosts
#
# Sample usage:
#
#     vb_apache2::vhost { 'php.vbox.tld' :
#        virtual_host => 'hudson.vbox.tld',
#        priority => '001',
#     } 
#
define vb_apache2::vhost ( $priority='', $urlalias='', $aliastgtpath='', $virtual_host ='' ) {

    include vb_apache2
    include vb_hosts
    
    if $priority == '' {
        fail("FAIL: Missing required parameter priority ($priority).")
    }
    
    if $priority == '000' {
        fail("FAIL: Priority ($priority) can not be 000 - reserved for default site.")
    }
    
    if ($urlalias != '') {
    
        if ($aliastgtpath !='') {
        
        	file { "$aliastgtpath": ensure => "directory" }
            
        } else {
        
            fail("FAIL: Target Alias path can not be empty if an urlalias ($urlalias) is given.")
            
        }
         
    }
    
    
    file { "/etc/apache2/sites-available/${name}":
        content =>  template('vb_apache2/vhost.erb'),
          owner => 'root',
          group => 'root',       
        require => Class["vb_apache2::install"],
    }
    
    ## Enable the vhost site
    
    file { "/etc/apache2/sites-enabled/${priority}-${name}":
        ensure => 'link',
        target => "/etc/apache2/sites-available/${name}",
       require => File["/etc/apache2/sites-available/${name}"],
        notify => Service["apache2"], 
    }

	# Create the initial directory for the vhost site
    
	file { "/var/www/${name}":
		ensure => "directory",
		owner => 'root',
		group => 'root',
	}
    
	file { "/var/www/${name}/public":
		 ensure => "directory",
		 owner => 'root',
		 group => 'root',
		require => File["/var/www/${name}"],
	}
	
    # vhost site initial index file and favicon
    
    file { "/var/www/${name}/public/index.html":
         source => "puppet:///modules/vb_apache2/newvhost.index.html",    
          owner => 'root',
          group => 'root',
        require => File["/var/www/${name}"],
    }
    
    file { "/var/www/${name}/public/favicon.ico":
         source => "puppet:///modules/vb_apache2/tux-favicon.ico",    
          owner => 'root',
          group => 'root',
        require => File["/var/www/${name}"],
    }
    
    # Add the new virtual host to /etc/hosts for name resolution
    
    vb_hosts::hosts { "$name" :
        apache_virtual_host => $virtual_host,
    }
    
        
    # $hosts_file = "/etc/hosts"
    # $hostipaddress = $::ipaddress
    
    #$line = "$hostipaddress $name"
    #
    #exec { "/bin/echo $line >> $hosts_file":
    #    path   => "/usr/bin:/usr/sbin:/bin",
    #    unless => "/bin/grep -Fx $line $hosts_file 2>/dev/null"
    #}
    #
}