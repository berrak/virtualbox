#
# Manage apache2
#
class puppet_apache::install {

    package { "apache2-mpm-prefork" : ensure => installed }

}