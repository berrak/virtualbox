#
# Manage PostgreSQL-9.1
#
class vb_postgresql::install {

    package { "postgresql"                : ensure => installed }
    package { "postgresql-client"         : ensure => installed }
    package { "pgadmin3"                  : ensure => installed }
    package { "postgresql-server-dev-9.1" : ensure => installed }    

}