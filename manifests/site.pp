#
# site.pp
#
node 'safesurf.vbox.tld' {
    
    class { vb_hosts::config : puppetserver_hostname => 'safesurf' }
    
    include vb_puppetize
    
    include vb_root_home
    
}

node 'perlmojo.vbox.tld' {
        
    class { vb_hosts::config : puppetserver_hostname => 'perlmojo' }
    
    include vb_puppetize
    
    include vb_root_home
    
}