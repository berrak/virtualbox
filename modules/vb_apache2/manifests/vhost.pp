#
# Define new Apache2 virtual hosts in var/www file system and enables it
#
# Sample usage:
#
#     vb_apache2::vhost { 'hudson.vbox.tld' :
#        priority => '001',
#        homeuser => 'bekr',
#     } 
#
define vb_apache2::vhost ( $priority='', $homeuser='', $urlalias='', $aliastgtpath='') {

    
    # Add a new virtual host fqdn to /etc/hosts for name resolution. This
    # is done in site.pp and 'vb_hosts' parameter 'apache_virtual_hosts'
    
    include vb_apache2
    
    if $homeuser == '' {
        fail("FAIL: Missing user write permission for user public directory ($homeuser).")
    }

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
         notify => Service["apache2"], 
    }
    
    ## Enable the vhost site
    
    file { "/etc/apache2/sites-enabled/${priority}-${name}":
        ensure => 'link',
        target => "/etc/apache2/sites-available/${name}",
       require => File["/etc/apache2/sites-available/${name}"],
    }

	# Create the initial directory for the vhost site
    
	file { "/var/www/${name}":
		ensure => "directory",
		owner => 'root',
		group => 'root',
	}
    
    
    # public directory is writable by user and apache (www-data)
	
    file { "/var/www/${name}/public" :
		 ensure => "directory",
		 owner => $homeuser,
		 group => 'www-data',
         mode => '0775',
		require => File["/var/www/${name}"],
	}
    
    file { [ "/var/www/${name}/public/images", "/var/www/${name}/public/thumbnails" ] :
		 ensure => "directory",
		 owner => $homeuser,
		 group => 'www-data',
         mode => '0775',
		require => File["/var/www/${name}/public"],
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
    
}