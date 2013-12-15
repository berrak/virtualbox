#########################################
## (BASENODE) Included in every node
#########################################
node basenode {
    
    # Manage Puppet itself 
    include vb_puppetize
    
    # Set up roots' home directories and bash customization
    include vb_root_home
    include vb_root_bashrc
    
    # Set up every VM with openssh server
    include vb_ssh_server
    
    # Configure APT
    include vb_aptconf
    

}