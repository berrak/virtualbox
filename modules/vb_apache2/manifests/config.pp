#
# Manage apache2
#
class vb_apache2::config {

    # Global security settings
    
    file { '/etc/apache2/conf.d/security':
         source => "puppet:///modules/vb_apache2/security",    
          owner => 'root',
          group => 'root',
        require => Class["vb_apache2::install"],
        notify => Service["apache2"],
    }

    file { '/etc/apache2/ports.conf':
        content =>  template('vb_apache2/ports.conf.erb'),
          owner => 'root',
          group => 'root',       
        require => Class["vb_apache2::install"],
        notify => Service["apache2"],
    }
    
    ## Configure the default vhost (catch all for an unmatched site)
    
	$default_fqdn = $::fqdn
	$site_domain = $::domain
	
    file { '/etc/apache2/sites-available/default':
        content =>  template('vb_apache2/default.erb'),
          owner => 'root',
          group => 'root',       
        require => Class["vb_apache2::install"],
    }

    ## Enable the default vhost site
    
    file { '/etc/apache2/sites-enabled/000-default':
        ensure => 'link',
        target => '/etc/apache2/sites-available/default',
       require => Class["vb_apache2::install"],
	    notify => Service["apache2"],
    }
    
	## Ensure that /var/www really exists!
	
	file { "/var/www":
		ensure => "directory",
		owner => 'root',
		group => 'root',
	}	
	
    
	# Create the directory structure for the default site
    
	file { "/var/www/default":
		 ensure => "directory",
		  owner => 'root',
		  group => 'root',
		require => File["/var/www"],		
	}
    
	# Doc root
	
	file { "/var/www/default/public":
		 ensure => "directory",
		 owner => 'root',
		 group => 'root',
		require => File["/var/www/default"],
	}
	
    # Default site index file and favicon (used when site does maintenence)
    
    file { '/var/www/default/public/index.html':
         source => "puppet:///modules/vb_apache2/default.index.html",    
          owner => 'root',
          group => 'root',
        require => File["/var/www/default"],
    }

    file { '/var/www/default/public/favicon.ico':
         source => "puppet:///modules/vb_apache2/tux-favicon.ico",    
          owner => 'root',
          group => 'root',
        require => File["/var/www/default"],
    }  

    # Images in /default/static

	file { "/var/www/default/public/images":
		 ensure => "directory",
		 owner => 'root',
		 group => 'root',
	}
	
    file { '/var/www/default/public/images/toolbox.jpg':
         source => "puppet:///modules/vb_apache2/tux-toolbox.jpg",    
          owner => 'root',
          group => 'root',
        require => File["/var/www/default/public/images"],
    }
    
    # Possible style sheets in /styles
	
	file { "/var/www/default/public/styles":
		 ensure => "directory",
		 owner => 'root',
		 group => 'root',
	}	
	
	
    
}