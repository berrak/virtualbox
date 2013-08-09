##
## Puppet manage openssh server
##
class vb_ssh_server {

    include vb_ssh_server::install, vb_ssh_server::service

}