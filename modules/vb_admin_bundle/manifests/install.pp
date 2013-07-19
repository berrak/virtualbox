#
# Define a predefined package sets (bundles) to be
# to be installed on a node. Note: not for services.
#
# Sample usage:
#            vb_admin_bndl::install { 'officeapps' : }
#            vb_admin_bndl::install { 'developerapps': }
#
define vb_admin_bndl::install {
  
    if ! ( $name in [ 'officeapps', 'developerapps', 'cliadminapps' ]) {
        fail("FAIL: Package bundle parameter ($name) not recognized!")
    }
  
  
    case $name {
    
        officeapps : {
        
            # Applications in addition to the default
            # Debian (wheezy) LXDE desktop installation.
            
            package  { [ 'evince' ] :
                ensure => installed }
        
        }

        cliadminapps : {
        
            # Can be applied to desktops and non-public servers
            #--------------------------------------------------
            # curl: transfer data with URL syntax
			
            package  { [ 'curl' ] :
                ensure => installed }
				
		}
        
        developerapps : {
        
            # build-essential: various Debian tools
          
	        package  { [ 'build-essential']:
                 ensure => installed }
        
		    ## Add some perl tools:
			# perltidy: perl script indenter and formatter
			# perl-doc: use 'perldoc' to read extended module information 

	        package  { [ 'perl-doc', 'perltidy']:
                 ensure => installed }
		}

        
        default: {}
        
    }

}