#
# Define a predefined package sets (bundles) to be
# to be installed on a node. Note: not for services.
#
# Sample usage:
#            vb_admin_bndl::install { 'officeapps' : }
#            vb_admin_bndl::install { 'developerapps': }
#
define vb_admin_bndl::install {
  
    if $name == 'officeapps' {
    
		package  { 'evince' :
			ensure => installed
			
		}
        
    
	}


}