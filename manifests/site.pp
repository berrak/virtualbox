#
# site.pp
#
node 'web.vbox.tld' {
    
    class { vb_hosts::config : puppetserver_hostname => 'web' }
    
    include vb_puppetize
    
    include vb_root_home
    
}

node 'mojo.vbox.tld' {
        
    class { vb_hosts::config : puppetserver_hostname => 'mojo' }
    
    include vb_puppetize
    
    include vb_root_home
    
}