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
    
    # get apt and add the key from ubuntu key server
    exec { "/usr/bin/apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 5AF261D4" :
              alias => 'add-apt-key-5AF261D4-opencobolide',
          subscribe => File["/etc/apt/sources.list.d/opencobolide.list"],
		refreshonly => true,
        notify => Exec["/usr/bin/apt-get update"],
	}	     
  
    # Update APT cache, but only when 'opencobolide.list' file changes

	exec { "/usr/bin/apt-get update" :
              alias => 'apt-get-update',
		refreshonly => true,
	}	    

    # required Wheezy debs by open-cobol-ide
    package { 'python-setuptools' : ensure => installed }
    package { 'python-chardet' :    ensure => installed } 
    package { 'python-qt4' :        ensure => installed }

    
    # need version 1.6 python-pygments (from testing) for cobol syntax checks
    # Note: 'apt-get install -t testing python-pygment' will not install
    # to latest revision, BUT 'apt-get install python-pygment/testing' does!
   
	exec { "/usr/bin/apt-get install python-pygments/testing" :
		refreshonly => true,
	}	    
    
    # install the opencobol IDE packages from launchpad PPA
    
    package { 'python-pyqode.core' :
         ensure => installed,
        require => [ Package["python-setuptools"], Package["python-chardet"], Package["python-qt4"], Exec["/usr/bin/apt-get install python-pygments/testing"] ],
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