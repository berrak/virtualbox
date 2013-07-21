#
# Manage apache2
#
class puppet_apache {

    include puppet_apache::install, puppet_apache::config, puppet_apache::service

}