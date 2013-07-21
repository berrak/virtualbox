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
    include vb_lxde_fixconfig
    
}

## Purpose is to work with Perl web frameworks e.g. Mojolicious

node 'node-mojo.vbox.tld' inherits basenode {
    
    # Packages without any special configurations
    include vb_install_debs
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
    # Fix LXDE configuration file (bug)
    include vb_lxde_fixconfig

}
## Purpose is to work with php development
node 'node-php.vbox.tld' inherits basenode {
    
    # Packages without any special configurations
    include vb_install_debs
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
    # Fix LXDE configuration file (bug)
    include vb_lxde_fixconfig
    
    include puppet_apache
    
    
}
