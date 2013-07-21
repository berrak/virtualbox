#
# Manage apache2
#
class puppet_apache::config {

    # Global security settings
    
    file { '/etc/apache2/conf.d/security':
         source => "puppet:///modules/puppet_apache/security",    
          owner => 'root',
          group => 'root',
        require => Class["puppet_apache::install"],
        notify => Service["apache2"],
    }

    $wwwipaddress = $::ipaddress
    $localhostaddress = '127.0.0.1'

    file { '/etc/apache2/ports.conf':
        content =>  template('puppet_apache/ports.conf.erb'),
          owner => 'root',
          group => 'root',       
        require => Class["puppet_apache::install"],
        notify => Service["apache2"],
    }
    
    ## Configure the default vhost (catch all for an unmatched site)
    
    file { '/etc/apache2/sites-available/default':
        content =>  template('puppet_apache/default.erb'),
          owner => 'root',
          group => 'root',       
        require => Class["puppet_apache::install"],
    }

    ## Enable the default vhost site
    
    file { '/etc/apache2/sites-enabled/000-default':
        ensure => 'link',
        target => '/etc/apache2/sites-available/default',
       require => Class["puppet_apache::install"],
    }
    
    ## Configure the localhost vhost (catch all for an unmatched site)
    
    file { '/etc/apache2/sites-available/localhost':
        content =>  template('puppet_apache/localhost.erb'),
          owner => 'root',
          group => 'root',       
        require => Class["puppet_apache::install"],
    }

    ## Enable the localhost vhost site
    
    file { '/etc/apache2/sites-enabled/000-localhost':
        ensure => 'link',
        target => '/etc/apache2/sites-available/localhost',
       require => Class["puppet_apache::install"],
    }
    
    
	# Create the directory for the default and localhost vhost site
    
	file { "/var/www/www.default.tld":
		ensure => "directory",
		owner => 'root',
		group => 'root',
		mode => '0755',
	}
    
    # Default and localhost index file (maintenance and picture) and the favicon
    
    file { '/var/www/www.default.tld/index.html':
         source => "puppet:///modules/puppet_apache/default.index.html",    
          owner => 'root',
          group => 'root',
        require => File["/var/www/www.default.tld"],
    }
    
    # temporary removed due to un-known/un-trusted source of jpg file (400x305 px)
    #file { '/var/www/www.default.tld/toolbox.jpg':
    #     source => "puppet:///modules/puppet_apache/toolbox.jpg",    
    #      owner => 'root',
    #      group => 'root',
    #    require => File["/var/www/www.default.tld"],
    #}
    
    file { '/var/www/www.default.tld/favicon.ico':
         source => "puppet:///modules/puppet_apache/tux-favicon.ico",    
          owner => 'root',
          group => 'root',
        require => File["/var/www/www.default.tld"],
    }  
    
}