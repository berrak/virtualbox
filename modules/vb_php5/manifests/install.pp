#
# Install PHP5 and some extra packages
#
class vb_php5::install {

    include vb_apache2
    
    package { ["php5", "php5-gd" ]:
        ensure => installed,
        require => Class["vb_apache2"],
    }


}