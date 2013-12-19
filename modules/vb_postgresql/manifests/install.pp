#
# Manage PostgreSQL-9.1
#
class vb_postgresql::install {

    # user
    package { "postgresql"                : ensure => installed }
    package { "postgresql-client"         : ensure => installed }
    package { "pgadmin3"                  : ensure => installed }
    
    # development 
    package { "postgresql-server-dev-9.1" : ensure => installed }
    package { "libecpg-dev"               : ensure => installed }
    

}