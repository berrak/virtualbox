#
# Simple module to install Debian packages which does not require any complicated setups
#
class vb_install_debs ( $debs ='' ) {


    if $debs == '' {
        fail("FAIL: Missing list of Debian package names ($debs) to install!")
    }

    # debs is an array of deb package names, defined in site.pp
    
    package { $debs : ensure => installed }





}