#########################################
## (BASENODE) Included in every node
#########################################
node basenode {

    # Manage the /etc/hosts file
    include vb_hosts
    
    # Manage Puppet itself 
    include vb_puppetize
    
    # Set up roots' home directories and bash customization
    include vb_root_home
    include vb_root_bashrc


}