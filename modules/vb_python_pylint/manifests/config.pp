#
# Class to configure pylint
#
define vb_python_pylint::config {

    include vb_python_pylint

    if $name == '' {
        fail("FAIL: No user ($name) given as argument.")
    }
    
    file { "/home/${name}/pylint":
        ensure => "directory",
         owner => "$name",
         group => "$name",
    }
    
	file { "/home/${name}/pylint/pylintrc":
		 source => "puppet:///modules/vb_python_pylint/pylintrc",
          owner => "$name",
          group => "$name",
		require => File["/home/${name}/pylint"],
	}
    
}