#
# Manage PostgreSQL-9.1
#
class vb_postgresql::service {

    service { "postgresql":
        enable => true,
        ensure => running,
        require => Package[postgresql],
    }
    
}