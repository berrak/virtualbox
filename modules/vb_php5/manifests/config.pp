#
# Configure PHP5
#
class vb_php5::config ($inifile='') {

    include vb_php5
    include vb_apache2

    case $inifile {
    
        'production':  {
      
            file { "/etc/php5/apache2/php.ini" :
                 source => "puppet:///modules/vb_php5/php.ini-production",    
                  owner => 'root',
                  group => 'root',
                require => Class["vb_php5::install"],
                 notify => Service["apache2"],
            }
            
        }
      
        'development': {
      
            file { "/etc/php5/apache2/php.ini" :
                 source => "puppet:///modules/vb_php5/php.ini-development",    
                  owner => 'root',
                  group => 'root',
                require => Class["vb_php5::install"],
                 notify => Service["apache2"],
            }
            
        }
      
        default: {
            fail("FAIL: Initype ($inifile) must be either 'production' or 'development'")
        }
    
    }
    
}