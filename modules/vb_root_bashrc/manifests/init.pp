##
## This class customize root's .bashrc
##
class vb_root_bashrc {


    # This file is Debian original + one source statement for .bash_root 
	file { "/root/.bashrc":
		source => "puppet:///modules/vb_root_bashrc/bashrc",
		 owner => 'root',
		 group => 'root',
		  mode => '0600',
	}

    # This file contains all customization for root
	file { "/root/.bashrc_root":
		source => "puppet:///modules/vb_root_bashrc/bashrc_root",
		 owner => 'root',
		 group => 'root',
		  mode => '0600',
		require => File["/root/.bashrc"],
	}
	
	# if one or both of these files are created/changed, source .bashrc
	exec { "reloadbashrc":
		command => '/bin/sh . /root/.bashrc',
		subscribe => File["/root/.bashrc"],
		refreshonly => true,
	}
	
	exec { "reloadadmbashrc":
		command => '/bin/sh . /root/.bashrc',
		subscribe => File["/root/.bashrc_root"],
		refreshonly => true,
	}
	

}
