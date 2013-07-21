#
# Manage apache2
#
class puppet_apache::service {

    service { "apache2":
        enable => true,
        ensure => running,
        require => Package[apache2-mpm-prefork],
    }
    
}