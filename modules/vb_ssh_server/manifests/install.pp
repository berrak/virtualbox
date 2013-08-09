##
## Puppet manage openssh server
##
class vb_ssh_server::install {
    
    package { "openssh-server": ensure => installed }
 
}