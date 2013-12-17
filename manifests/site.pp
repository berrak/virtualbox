#
# site.pp (Virtualbox VM's)
#

import 'base.pp'

## Purpose is to build a hardened SERVER host - Note no GUI desktop/LXDE

node default inherits basenode {
        
    # Manage /etc/hosts file
    include vb_hosts
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
}

node 'node-hard.vbox.tld' inherits basenode {
        
    
    # Manage /etc/hosts file
    include vb_hosts
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
}

## Purpose is to build an isolated desktop for safer WEB experience

node 'node-web.vbox.tld' inherits basenode {
    
    # Manage /etc/hosts file
    include vb_hosts
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
    # Fix LXDE configuration file (bug)
    class { vb_lxde_fixconfig : homeuser => 'bekr' }
    
}

## Purpose is to work with PERL web frameworks e.g. MOJOLICIOUS

node 'node-mojo.vbox.tld' inherits basenode {
    
    # Manage /etc/hosts file
    include vb_hosts
    
    # Packages without any special configurations
    class { vb_install_debs : debs => [ "curl", "evince", "wdiff" ] }
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
    # Fix LXDE configuration file (bug)
    class { vb_lxde_fixconfig : homeuser => 'bekr' }

}
## Purpose is to work with PHP development

node 'node-php.vbox.tld' inherits basenode {
    
    # Packages without any special configurations
    class { vb_install_debs : debs => [ "curl", "evince", "wdiff" ] }
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
    # Fix LXDE configuration file (bug)
    class { vb_lxde_fixconfig : homeuser => 'bekr' }
    
    class { vb_php5::config : inifile => 'development' }
    
    # Use apache2 prefork
    include vb_apache2
    
    # Define a new Apache2 virtual host (docroot directory writable by group 'bekr')
    vb_apache2::vhost { 'hudson.vbox.tld' :
            priority => '001',
       devgroupid => 'bekr',
    }
    
    # Define a new Apache2 virtual host (docroot directory writable by group 'bekr')
    vb_apache2::vhost { 'powers.vbox.tld' :
            priority => '002',
       devgroupid => 'bekr',
       scriptlanguage => 'php',
    }
    
    # Define content in /etc/hosts file. List ALL Apache VIRTUAL HOSTS here, declare always default www.vbox.tld.
    vb_hosts::config { 'bekr' : apache_virtual_host => [ "www.vbox.tld", "hudson.vbox.tld", "powers.vbox.tld" ] }    

}

## Purpose is to work with RUBY development

node 'node-ruby.vbox.tld' inherits basenode {
    
    # Manage /etc/hosts file
    include vb_hosts
    
    # Packages without any special configurations
    class { vb_install_debs : debs => [ "rubygems", "ruby-json", "ruby-net-http-persistent", "curl", "evince", "wdiff" ] }
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
    # Fix LXDE configuration file (bug)
    class { vb_lxde_fixconfig : homeuser => 'bekr' }

}

## Purpose is to work with PYTHON development

node 'node-python.vbox.tld' inherits basenode {
    
    # Manage /etc/hosts file
    include vb_hosts
    
    # user git client
    vb_gitclient::config { 'bekr' : mygitname => 'debinix', mygitemail => 'bkronmailbox-git2@yahoo.se' }
    
    # Packages without any special configurations
    class { vb_install_debs : debs => [ "curl", "evince", "wdiff", "pyflakes", "python-sphinx", "sphinx-doc" ] }
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
    # Fix LXDE configuration file (bug)
    class { vb_lxde_fixconfig : homeuser => 'bekr' }
    
    # Lint checker
    vb_python_pylint::config { 'bekr' : }

}


## Purpose is to work with COBOL development

node 'node-cobol.vbox.tld' inherits basenode {
    
    # Manage /etc/hosts file
    include vb_hosts
    
    # user git client
    vb_gitclient::config { 'bekr' : mygitname => 'debinix', mygitemail => 'bkronmailbox-git2@yahoo.se' }
    
    # Packages without any special configurations
    class { vb_install_debs : debs => [ "eclipse", "rubygems", "ruby-json", "ruby-net-http-persistent" ] }
    
    # Use apache2 prefork
    include vb_apache2
    
    # Define a new Apache2 virtual host (docroot directory writable by group 'bekr')
    vb_apache2::vhost { 'jensen.vbox.tld' :
            priority => '001',
          devgroupid => 'bekr',
       scriptlanguage => 'cgi',
    }
    
    # Manage /etc/hosts file. List ALL Apache VIRTUAL HOSTS here, declare always default www.vbox.tld.
    vb_hosts::config { 'bekr' : apache_virtual_host => [ "www.vbox.tld", "jensen.vbox.tld"  ] }      
    
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
    # Fix LXDE configuration file (bug)
    class { vb_lxde_fixconfig : homeuser => 'bekr' }

    # need some some packages from testing for open-cobol-ide
    vb_add_aptrelease::config { 'testing' : }
    include vb_opencobolide_ppa
    
    # PostgreSQL-9.1
    include vb_postgresql
    
    # following does not run at all by Puippet, but is Ok at cmd-line! 
    # vb_postgresql::add_dbuser { 'bekr' : }
    # vb_postgresql::create_database { 'jensen' : owner => 'bekr' }
    

}


## Purpose is to work with java and javascript development

node 'node-java.vbox.tld' inherits basenode {
    
    # Manage /etc/hosts file
    include vb_hosts
    
    # Packages without any special configurations (installs eclipse 3.8)
    class { vb_install_debs : debs => [ "eclipse" ] }
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
    # Fix LXDE configuration file (bug)
    class { vb_lxde_fixconfig : homeuser => 'bekr' }

}


## Purpose is to work with Debian packaging tools (testing/unstable)

node 'node-sid.vbox.tld' inherits basenode {
    
    # Manage /etc/hosts file
    include vb_hosts
    
    # Packages without any special configurations
    class { vb_install_debs : debs => [ "patchutils", "quilt" ] }
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
    # Fix LXDE configuration file (bug)
    class { vb_lxde_fixconfig : homeuser => 'bekr' }

}



