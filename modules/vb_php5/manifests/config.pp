#
# Configure PHP5
#
class vb_php5::config {

    file { "/etc/php5/apache2/php.ini" :
        content => template( "vb_php5/php.ini.erb" ),
          owner => 'root',
          group => 'root',
        require => Class["vb_php5::install"],
    }

}