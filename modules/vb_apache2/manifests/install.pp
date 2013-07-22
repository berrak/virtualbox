#
# Manage apache2
#
class vb_apache2::install {

    package { "apache2-mpm-prefork" : ensure => installed }

}