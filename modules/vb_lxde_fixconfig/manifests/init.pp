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
    
    # These changes make code more robust in case ecec on server without GUI.
    # Required - for below fix, make sure dirs exists (lxde config directory)

    file { "/home/${homeuser}/.config":
        ensure => "directory",
         owner => "${homeuser}",
         group => "${homeuser}",
    }
    
    # Here fix bug in lxterminal, such that user can't make the
    # configuration persistent (Debian sets this as root ownership).
    
    file { "/home/${homeuser}/.config/lxterminal":
         ensure => "directory",
          owner => "${homeuser}",
          group => "${homeuser}",
           mode => '0755',
        require => File["/home/${homeuser}/.config"],
    }
    
    # Fix bug only if config file exists (i.e. skip on servers)
    
    exec { "/home/${homeuser}/.config/lxterminal/lxterminal.conf":
             command => "/bin/chown ${homeuser}:${homeuser} /home/${homeuser}/.config/lxterminal/lxterminal.conf",
              onlyif => "/usr/bin/test -x /home/${homeuser}/.config/lxterminal/lxterminal.conf",
             require => File["/home/${homeuser}/.config/lxterminal"],
    }


}