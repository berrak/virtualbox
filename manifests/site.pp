#
# site.pp (Virtualbox VM's)
#
## Purpose is to build a hardened server host
node 'node-hard.vbox.tld' {
    
    include vb_hosts
    
    include vb_puppetize
    
    include vb_root_home
    
    include vb_root_bashrc
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
}
## Purpose is to build a isolated hardened host for a safer web experience
node 'node-web.vbox.tld' {
    
    include vb_hosts
    
    include vb_puppetize
    
    include vb_root_home
    
    include vb_root_bashrc
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
}
## Purpose is to work with Perl web frameworks e.g. Mojolicious
node 'node-mojo.vbox.tld' {
        
    include vb_hosts
    
    include vb_puppetize
    
    include vb_root_home
    
    include vb_root_bashrc
    
    # Packages which not requires any special configuration i.e. debs as maintained by Debian
    include vb_install_debs
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }

}
## Purpose is to work with php development
node 'node-php.vbox.tld' {
    
    include vb_hosts
    
    include vb_puppetize
    
    include vb_root_home
    
    include vb_root_bashrc
    
    # Packages which not requires any special configuration i.e. debs as maintained by Debian
    include vb_install_debs
    
    # Replace 'bekr' with your existing username
    vb_user_bashrc::config { 'bekr' : }
    
}
