#
# Manage PostgreSQL-9.1
#
class vb_postgresql {

    include vb_postgresql::install, vb_postgresql::config, vb_postgresql::service

}