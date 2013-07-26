#
# Class to configure pylint
#
class vb_python_pylint::config ( $pythonuser ='' ) {

    if $pythonuser == '' {
        fail("FAIL: No user ($pythonuser) given as argument.")
    }
    
    file { "/home/${pythonuser}/pylint":
        ensure => "directory",
         owner => "${pythonuser}",
         group => "${pythonuser}",
    }
    
	file { "/home/${pythonuser}/pylint/pylintrc":
		 source => "puppet:///modules/vb_python_pylint/pylintrc",
          owner => "${pythonuser}",
          group => "${pythonuser}",
		require => File["/home/${pythonuser}/pylint"],
	}
    
}