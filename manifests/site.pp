#
# site.pp (Virtualbox VM's)
#

import 'base.pp'

## Purpose is to build a hardened SERVER host - Note no GUI desktop/LXDE

node 'node-hard.vbox.tld' inherits basenode {
        
    
    # Manage /etc/hosts file
    vb_hosts { 'hard.vbox.tld' : }
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
}

## Purpose is to build an isolated desktop for safer WEB experience

node 'node-web.vbox.tld' inherits basenode {
    
    # Manage /etc/hosts file
    vb_hosts { 'web.vbox.tld' : }
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
    # Fix LXDE configuration file (bug)
    class { vb_lxde_fixconfig : homeuser => 'bekr' }
    
}

## Purpose is to work with PERL web frameworks e.g. MOJOLICIOUS

node 'node-mojo.vbox.tld' inherits basenode {
    
    # Manage /etc/hosts file
    vb_hosts { 'mojo.vbox.tld' : }
    
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
    
    include vb_php5
    
    # Use apache2 prefork
    include vb_apache2
    
    # Define a new Apache2 virtual host
    vb_apache2::vhost { 'hudson.vbox.tld' : priority => '001' }
    
    # Manage /etc/hosts file, also new Apache virtual hosts
    #vb_hosts { 'php.vbox.tld' : apache_virtual_host => 'hudson.vbox.tld' }    
    vb_hosts { 'php.vbox.tld' : }    
}

## Purpose is to work with RUBY development

node 'node-ruby.vbox.tld' inherits basenode {
    
    # Manage /etc/hosts file
    vb_hosts { 'ruby.vbox.tld' : }   
    
    # Packages without any special configurations
    class { vb_install_debs : debs => [ "curl", "evince", "wdiff" ] }
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
    # Fix LXDE configuration file (bug)
    class { vb_lxde_fixconfig : homeuser => 'bekr' }

}

## Purpose is to work with PYTHON development

node 'node-python.vbox.tld' inherits basenode {
    
    # Manage /etc/hosts file
    vb_hosts { 'python.vbox.tld' : }   
    
    # Packages without any special configurations
    class { vb_install_debs : debs => [ "curl", "evince", "wdiff", "pyflakes" ] }
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
    # Fix LXDE configuration file (bug)
    class { vb_lxde_fixconfig : homeuser => 'bekr' }
    
    # Lint checker
    vb_python_pylint::config { 'bekr' : }

}
