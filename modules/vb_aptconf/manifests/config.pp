##
## This class configures APT
##
class vb_aptconf::config {


	# Debian Wheezy, Debian security and Debian Update repos

	file { "/etc/apt/sources.list":
		source => "puppet:///modules/vb_aptconf/sources.list",
		 owner => "root",
		 group => "root",
		  mode => '0644',
	}

	## Configuration for APT
	
	file { "/etc/apt/apt.conf":
		source => "puppet:///modules/vb_aptconf/apt.conf",
		 owner => 'root',
		 group => 'root',
		  mode => '0644',

	}	
	
}
