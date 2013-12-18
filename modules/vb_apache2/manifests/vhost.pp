#
# Define new Apache2 virtual hosts in var/www file system and enables it
#
# Sample usage:
#
#     vb_apache2::vhost { 'hudson.vbox.tld' :
#        priority => '001',
#        devgroupid => 'bekr',
#        execscript = 'php',
#     } 
#
define vb_apache2::vhost ( $priority='', $devgroupid='', $urlalias='', $aliastgtpath='', $execscript='') {

    
    # Add a new virtual host fqdn to /etc/hosts for name resolution. This
    # is done in site.pp and 'vb_hosts' parameter 'apache_virtual_hosts'
    
    include vb_apache2
    
    if $devgroupid == '' {
        fail("FAIL: Missing group name for developer work under /var/www-directory tree ($devgroupid) or the /home/userid of the suexec user.")
    }

    if $priority == '' {
        fail("FAIL: Missing required parameter priority ($priority).")
    }
    
    if $execscript == '' {
        fail("FAIL: Missing required execscript parameter ($execscript).")
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
    
    
	## Create the COMMON directories for this vhost site
    
	
    if $execscript != 'suexec' {
    
        file { "/var/www/${name}":
            ensure => "directory",
            owner => 'root',
            group => 'root',
             mode => '0775',        
        }
        
        # public directory is writable by developer group to be able to update files
        
        file { "/var/www/${name}/public" :
             ensure => "directory",
             owner => 'root',
             group => $devgroupid,
             mode => '0775',
            require => File["/var/www/${name}"],
        }
        
    } else {
    
        # this (suexec)user must exist on the host system - not created by Puppet!
    
        file { "/home/${devgroupid}/${name}":
            ensure => "directory",
            owner => $devgroupid,
            group => $devgroupid,
             mode => '0775',        
        }
        
        # docroot for the suexec execution
        
        file { "/home/${devgroupid}/${name}/public_html" :
             ensure => "directory",
              owner => $devgroupid,
              group => $devgroupid,
               mode => '0775',
            require => File["/home/${devgroupid}/${name}"],
        }

        # script directory /cgi-bin for suexec execution

        file { "/home/${devgroupid}/${name}/public_html/cgi-bin" :
             ensure => "directory",
              owner => $devgroupid,
              group => $devgroupid,
               mode => '0775',
            require => File["/home/${devgroupid}/${name}/public_html"],
        }        
    
    }
    
    
    ## Special vhost-configuration depending on (script)languages used
    
    case $execscript {
    
        'cgi': {
                
            file { "/etc/apache2/sites-available/${name}":
                content =>  template('vb_apache2/cgi.vhost.erb'),
                owner => 'root',
                group => 'root',       
                require => Class["vb_apache2::install"],
                notify => Service["apache2"],
            }
            
            # CGI-BIN directory (i.e. the document root)
    
            file { "/var/www/${name}/public/cgi-bin" :
                ensure => "directory",
                owner => 'root',
                group => $devgroupid,
                mode => '0775',
                require => File["/var/www/${name}/public"],
            }                
            
            
            # vhost site index.cgi file and favicon
    
            file { "/var/www/${name}/public/cgi-bin/index.cgi":
                source => "puppet:///modules/vb_apache2/newvhost.index.cgi",    
                owner => 'root',
                group => 'root',
                mode => '0755',
                require => File["/var/www/${name}/public/cgi-bin"],
            }   
    
            file { "/var/www/${name}/public/cgi-bin/favicon.ico":
                source => "puppet:///modules/vb_apache2/tux-favicon.ico",    
                 owner => 'root',
                 group => 'root',
                  mode => '0644',
                require => File["/var/www/${name}/public/cgi-bin"],
            }                       
            
        }
        
        'suexec': {
        
            # enable suEXEC apache module
            
            # need to install debian configurable suexec
            package { "apache2-suexec-custom" : ensure => installed }
            
            exec { "enable_apache2_suexec_module":
                command => "/usr/sbin/a2enmod suexec",
                require => Package["apache2-suexec-custom"],
            }
            
            file { '/etc/apache2/suexec/www-data':
                content =>  template('vb_apache2/suexec.custom.www-data.erb'),
                  owner => 'root',
                  group => 'root',       
                require => Package["apache2-suexec-custom"],
            }            
            
            file { "/etc/apache2/sites-available/${name}":
                content =>  template('vb_apache2/suexec.vhost.erb'),
                owner => 'root',
                group => 'root',       
                require => Class["vb_apache2::install"],
                notify => Service["apache2"],
            }
            
            # vhost site index.cgi file and favicon
    
            file { "/home/${devgroupid}/${name}/public_html/cgi-bin/sh.index.cgi":
                source => "puppet:///modules/vb_apache2/newvhost.index.cgi",    
                owner => $devgroupid,
                group => $devgroupid,
                mode => '0755',
                require => File["/home/${devgroupid}/${name}/public_html/cgi-bin"],
            }   
    
            file { "/home/${devgroupid}/${name}/public_html/cgi-bin/favicon.ico":
                 source => "puppet:///modules/vb_apache2/tux-favicon.ico",    
                  owner => $devgroupid,
                  group => $devgroupid,
                   mode => '0644',
                require => File["/home/${devgroupid}/${name}/public_html/cgi-bin"],
            }
        
        }
        
        
        'php': {
    
            file { "/etc/apache2/sites-available/${name}":
                content =>  template('vb_apache2/vhost.erb'),
                owner => 'root',
                group => 'root',       
                require => Class["vb_apache2::install"],
                notify => Service["apache2"],
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
        
        default: {
            fail("FAIL: Script language ($execscript) not defined or known!")
        }
    
    }
    
    #
    ## THIS SECTION SETUP A DEFAULT PHP DIRECTORY STRUCTURE AND FILE OWNERSHIPS FOR THIS VHOST
    #
    
    
    if $scriptlanguage == 'php' {
    
        # IMAGES directory (e.g. for PHP) for images
        
        file { "/var/www/${name}/public/images" :
             ensure => "directory",
             owner => 'root',
             group => $devgroupid,
             mode => '0775',
            require => File["/var/www/${name}/public"],
        }
        
        # STYLES directory (e.g. for PHP) for stylesheets
        
        file { "/var/www/${name}/public/styles" :
             ensure => "directory",
             owner => 'root',
             group => $devgroupid,
             mode => '0775',
            require => File["/var/www/${name}/public"],
        }   
        
        
        # Include files (e.g. for PHP) for developer group goes one directory level up   
    
        file { "/var/www/${name}/includes" :
             ensure => "directory",
             owner => 'root',
             group => $devgroupid,
             mode => '0775',
            require => File["/var/www/${name}"],
        }
        
    
        
        # STATIC data (e.g. for PHP) for application process (read), writable by developer group 
        
        file { "/var/www/${name}/static" :
             ensure => "directory",
             owner => 'root',
             group => $devgroupid,
             mode => '0775',
            require => File["/var/www/${name}"],
        }
    
        # Application DATA (read-writable by the eg. a PHP application i.e. www-data)
        
        file { "/var/www/${name}/data" :
             ensure => "directory",
             owner => 'www-data',
             group => 'root',
            require => File["/var/www/${name}"],
        }
    
    }
    
    
    ## Finally, enable the vhost site
    
    file { "/etc/apache2/sites-enabled/${priority}-${name}":
        ensure => 'link',
        target => "/etc/apache2/sites-available/${name}",
       require => File["/etc/apache2/sites-available/${name}"],
    }
    

    
    
    
}