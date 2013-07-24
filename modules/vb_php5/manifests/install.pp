#
# Install PHP5 and some extra packages
#
class vb_php5::install {

    package { ["php5", "php5-gd" ]: ensure => installed }


}