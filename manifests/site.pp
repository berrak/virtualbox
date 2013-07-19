#
# site.pp (Virtualbox VM's)
#
#
## Purpose is to build a hardened host for a safer web experience
node 'web.vbox.tld' {
    
    class { vb_hosts::config : puppetserver_hostname => 'web' }
    
    include vb_puppetize
    
    include vb_root_home
    
    include vb_root_bashrc
    
}
## Purpose is to work with Perl web frameworks e.g. Mojolicious
node 'mojo.vbox.tld' {
        
    class { vb_hosts::config : puppetserver_hostname => 'mojo' }
    
    include vb_puppetize
    
    include vb_root_home
    
    include vb_root_bashrc
    
    vb_admin_bndl::install { 'cliadminapps' : }
    vb_admin_bndl::install { 'officeapps' : }
    vb_admin_bndl::install { 'developerapps': }
    
}