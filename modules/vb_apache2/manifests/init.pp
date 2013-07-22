#
# Manage apache2
#
class vb_apache2 {

    include vb_apache2::install, vb_apache2::config, vb_apache2::service

}