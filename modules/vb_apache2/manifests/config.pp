#
# Manage apache2
#
class vb_apache2::config ($homeuser ='') {

    include vb_apache2::install, vb_apache2::service

    if $homeuser == '' {
	    fail("FAIL: Missing parameter user ($homeuser)!")
	}


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
    }
    
    ## Configure the localhost vhost (catch all for an unmatched site)
    
    file { '/etc/apache2/sites-available/localhost':
        content =>  template('vb_apache2/localhost.erb'),
          owner => 'root',
          group => 'root',       
        require => Class["vb_apache2::install"],
    }

    ## Enable the localhost vhost site
    
    file { '/etc/apache2/sites-enabled/000-localhost':
        ensure => 'link',
        target => '/etc/apache2/sites-available/localhost',
       require => Class["vb_apache2::install"],
    }
    
    
	# Create the directory for the default and localhost vhost site
	# Note: sets group rwx on directory for given 'homeuser'
    
	file { "/var/www/www.default.tld":
		ensure => "directory",
		owner => 'root',
		group => $homeuser,
		mode => '0775',
	}
    
    # Default and localhost index file (maintenance and picture) and the favicon
    
    file { '/var/www/www.default.tld/index.html':
         source => "puppet:///modules/vb_apache2/default.index.html",    
          owner => 'root',
          group => 'root',
        require => File["/var/www/www.default.tld"],
    }
    
    file { '/var/www/www.default.tld/toolbox.jpg':
         source => "puppet:///modules/vb_apache2/tux-toolbox.jpg",    
          owner => 'root',
          group => 'root',
        require => File["/var/www/www.default.tld"],
    }
    
    file { '/var/www/www.default.tld/favicon.ico':
         source => "puppet:///modules/vb_apache2/tux-favicon.ico",    
          owner => 'root',
          group => 'root',
        require => File["/var/www/www.default.tld"],
    }  
    
}