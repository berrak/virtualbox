#
# Define new Apache2 virtual hosts in var/www file system and enables it
#
# Sample usage:
#
#     vb_apache2::vhost { 'hudson.vbox.tld' :
#        priority => '001',
#        phpdevgroupid => 'bekr',
#     } 
#
define vb_apache2::vhost ( $priority='', $phpdevgroupid='', $urlalias='', $aliastgtpath='') {

    
    # Add a new virtual host fqdn to /etc/hosts for name resolution. This
    # is done in site.pp and 'vb_hosts' parameter 'apache_virtual_hosts'
    
    include vb_apache2
    
    if $phpdevgroupid == '' {
        fail("FAIL: Missing group name for developer work under /var/www-directory tree ($phpdevgroupid).")
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
  
  
    #
    ## THIS SECTION SETUP A DEFAULT DIRECTORY STRUCTURE AND FILE OWNERSHIPS FOR THIS VHOST
    #
    
    # PUBLIC directory (document-root) is writable by developer group 'phpdev' to be able to update files
	
    file { "/var/www/${name}/public" :
		 ensure => "directory",
		 owner => 'root',
		 group => $phpdevgroupid,
         mode => '0775',
		require => File["/var/www/${name}"],
	}
    
    # IMAGES directory for images
    
    file { "/var/www/${name}/public/images" :
		 ensure => "directory",
		 owner => 'root',
		 group => $phpdevgroupid,
         mode => '0775',
		require => File["/var/www/${name}/public"],
	}
    
    # STYLES directory for stylesheets
    
    file { "/var/www/${name}/public/styles" :
		 ensure => "directory",
		 owner => 'root',
		 group => $phpdevgroupid,
         mode => '0775',
		require => File["/var/www/${name}/public"],
	}   
    
    
    
    ## Developer directories for code are one directory level up
    
    # PHP main code for group developer
    
    file { "/var/www/${name}/code" :
		 ensure => "directory",
		 owner => 'root',
		 group => $phpdevgroupid,
         mode => '0775',
		require => File["/var/www/${name}"],
	}
	
    # PHP include files for developer group goes one directory below the code    

    file { "/var/www/${name}/code/includes" :
		 ensure => "directory",
		 owner => 'root',
		 group => $phpdevgroupid,
         mode => '0775',
		require => File["/var/www/${name}/code"],
	}
    

    
    # PHP STATIC data for application process (read), writable by developer group 
    
    file { "/var/www/${name}/static" :
		 ensure => "directory",
		 owner => 'root',
		 group => $phpdevgroupid,
         mode => '0775',
		require => File["/var/www/${name}"],
	}

    # PHP application DATA (read-writable by php app i.e. www-data)
    
    file { "/var/www/${name}/data" :
		 ensure => "directory",
		 owner => 'www-data',
		 group => 'root',
		require => File["/var/www/${name}"],
	}
    
}