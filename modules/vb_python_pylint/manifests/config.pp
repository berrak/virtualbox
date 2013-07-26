#
# Class to configure pylint
#
class vb_python_pylint::config ( $homeuser ='' ) {

    if $homeuser == '' {
        fail("FAIL: No user ($homeuser) given as argument.")
    }
    
    file { "/home/${homeuser}/pylint":
        ensure => "directory",
         owner => "${homeuser}",
         group => "${homeuser}",
    }
    
	file { "/home/${homeuser}/pylint/pylintrc":
		 source => "puppet:///modules/vb_python_pylint/pylintrc",
          owner => "${homeuser}",
          group => "${homeuser}",
		require => File["/home/${homeuser}/pylint"],
	}
    
}