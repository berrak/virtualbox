##
## This configures additional Debian releases
#
# Sample usage:
#
#     vb_add_aptrelease::config{ 'testing' : }
#       
##
define vb_add_aptrelease::config {


    if $name != 'testing' {
		fail("FAIL: Only testing is supported as an additional release to add to stable!")
	}


	# Add the named Debian release

	file { "/etc/apt/sources.list.d/$name.list":
		source => "puppet:///modules/vb_add_aptrelease/$name.sources.list",
		 owner => "root",
		 group => "root",
		  mode => '0644',
	}


    # Set preference release to stable (always)
	
	file { "/etc/apt/preferences":
		source => "puppet:///modules/vb_add_aptrelease/preferences",
		 owner => "root",
		 group => "root",
		  mode => '0644',
		  require => File["/etc/apt/sources.list.d/$name.list"],
	}	

    # Update APT cache, but only when preferences file changes

	exec { "/usr/bin/aptitude update" :
		subscribe   => File["/etc/apt/preferences"],
		refreshonly => true
	}	
	
	
}
