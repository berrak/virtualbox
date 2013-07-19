##
## Manage Puppet (Note: in a virtual setup, puppet master and agent always runs on same host)
##
class vb_puppetize {

    include vb_puppetize::install, vb_puppetize::config, vb_puppetize::service
}