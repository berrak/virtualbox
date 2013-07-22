#
# site.pp (Virtualbox VM's)
#

import 'base.pp'

## Purpose is to build a hardened server host - note no GUI desktop/LXDE

node 'node-hard.vbox.tld' inherits basenode {
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
}

## Purpose is to build a isolated hardened host for a safer web experience

node 'node-web.vbox.tld' inherits basenode {
      
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
    # Fix LXDE configuration file (bug)
    class { vb_lxde_fixconfig : homeuser => 'bekr' }
    
}

## Purpose is to work with Perl web frameworks e.g. Mojolicious

node 'node-mojo.vbox.tld' inherits basenode {
    
    # Packages without any special configurations
    class { vb_install_debs : debs => [ "curl", "evince", "php5"] }
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
    # Fix LXDE configuration file (bug)
    class { vb_lxde_fixconfig : homeuser => 'bekr' }

}
## Purpose is to work with php development
node 'node-php.vbox.tld' inherits basenode {
    
    # Packages without any special configurations
    class { vb_install_debs : debs => [ "curl", "evince", "php5"] }
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
    # Fix LXDE configuration file (bug)
    class { vb_lxde_fixconfig : homeuser => 'bekr' }
    
    # Use name-based virtual hosts, apache2 prefork and sets rwx to homeuser www-default directory
    class { vb_apache2::config : homeuser => 'bekr' }
     
    
}
