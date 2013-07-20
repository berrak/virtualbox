#
# Simple module to install Debian packages which does not require any complicated setups
#
class vb_install_debs {


    # Office apps
    package { 'evince' : ensure => installed }


    # Developer apps
    package { 'curl' : ensure => installed }


}