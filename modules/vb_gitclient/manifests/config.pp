##
## Configure global client git user name/email/editor etc.
##
## Sample use:
##
##     vb_git::config { 'bekr' : mygitname => 'debinix', mygitemail => 'mygitalias@example.com' }
##
define vb_gitclient::config ( $mygitname= '', $mygitemail='' ) {

    
	if ( $mygitname == '' ) or ( $mygitemail == '' ) {
	    fail("FAIL: Missing git alias ($mygitname) or git email ($mygitemail).")
	}
	
	include vb_gitclient::install
        
	# default editor and colorful logformat
	
    $mygiteditor = '/bin/nano'
	$mylogformat = '%Cred%h%Creset -%C(Yellow)%d%Creset%s%Cgreen(%cr) %C(bold blue)<%an>%Creset'
	
	
	# create a subdirectory for local repositories
	
	file { "/home/${name}/GIT":
		ensure => "directory",
		 owner => $name,
		 group => $name,
	}
    
	# gitclient cofiguration file
	
    file { "/home/${name}/.gitconfig" :
          content => template( 'vb_gitclient/gitconfig.erb' ),
            owner => $name,
            group => $name,
          require => Package["git"],
    }
    
 	# user git bashrc snippet
	
	file { "/home/${name}/bashrc.d/git.rc" :
		ensure => present,
		source => "puppet:///modules/vb_gitclient/git.rc",
		 owner => $name,
		 group => $name,
	}
 
 
    # need directory to save user ssh key for access to github
	
    file { "/home/${name}/.ssh":
		ensure => "directory",
		 owner => $name,
		 group => $name,
		  mode => '0700',
	} 
    
}