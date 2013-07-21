#
# Class to enable normal user to update the LXDE configuration file
#
class vb_lxde_fixconfig ( $homeuser ='' ) {

    # fix bug in 'lxterminal' - useer can't make LXDE configuration persistent
    # (installed configuration is by default set as root ownership!)
    
    # Change the directory.
    
    if $homeuser == '' {
        fail("FAIL: No user ($homeuser) given as argument.")
    }
    
    file { "/home/${homeuser}/.config/lxterminal":
        ensure => "directory",
         owner => "${homeuser}",
         group => "${homeuser}",
          mode => '0755',
    }
        
    # Change ownership of LXDE configuration file.
        
    exec { "/home/${homeuser}/.config/lxterminal/lxterminal.conf":
            command => "/bin/chown ${homeuser}:${homeuser} /home/${homeuser}/.config/lxterminal/lxterminal.conf",
          subscribe => File["/home/${homeuser}/.config/lxterminal"],
        refreshonly => true,
    }

}