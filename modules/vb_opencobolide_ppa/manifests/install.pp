#
# Python based OpenCobol IDE, from launchpad PPA
# https://launchpad.net/~open-cobol-ide/+archive/stable
# Key: 5AF261D4
#
class vb_opencobolide_ppa::install {

    # Note required in site.pp: vb_add_aptrelease::config { 'testing' : }
    # the 'testing' release is pin down such that stable is still default
    

    # required compiler(s)
    package { 'open-cobol' :
        ensure => installed,
    }
        
    
    # add the PPA repository to APT
    
	file { "/etc/apt/sources.list.d/opencobolide.list":
		 source => "puppet:///modules/vb_opencobolide_ppa/opencobolide.ppa.list",
		  owner => "root",
		  group => "root",
		   mode => '0644',
	}
    
    # add the key (5AF261D4) for the launchpad PPA
	exec { "/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5AF261D4" :
              alias => 'add-ppa-5AF261D4-opencobolide',
          subscribe => File["/etc/apt/sources.list.d/opencobolide.list"], 
		refreshonly => true,
	}	    
    
    # Update APT cache, but only when 'opencobolide.list' file changes

	exec { "/usr/bin/apt-get update" :
              alias => 'apt-get-update',
		subscribe   => File["/etc/apt/sources.list.d/opencobolide.list"],
		refreshonly => true,
	}	    

    # required Wheezy debs by open-cobol-ide
    package { 'python-setuptools' : ensure => installed }
    package { 'python-chardet' :    ensure => installed } 
    package { 'python-qt4' :        ensure => installed }

    
    # need version 1.6 python-pygments (testing) for cobol syntax checks
   
	exec { "/usr/bin/aptitude -t testing python-pygments" :
              alias => 'install-testing-pygments',
		refreshonly => true,
	}	    
    
    # install the opencobol IDE packages from launchpad PPA
    
    package { 'python-pyqode.core' :
         ensure => installed,
        require => [ Package["python-setuptools"], Package["python-chardet"], Package["python-qt4"], Exec["install-testing-pygments"] ],
    }
    
    package { 'python-pyqode.widgets' :
         ensure => installed,
        require => Package["python-pyqode.core"]
    }
    
    package { 'open-cobol-ide' :
         ensure => installed,
        require => Package["python-pyqode.widgets"]
    }    
    

}