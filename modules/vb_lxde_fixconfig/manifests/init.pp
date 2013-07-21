#
# Class to enable normal user to update the LXDE configuration file
#
class vb_lxde_fixconfig {

    # fix bug in 'lxterminal' - useer can't make LXDE configuration persistent
    # (installed configuration is by default set as root ownership!)
    
    # Change the directory.
    
    file { "/home/${name}/.config/lxterminal":
        ensure => "directory",
         owner => "${name}",
         group => "${name}",
          mode => '0755',
    }
        
    # Change ownership of LXDE configuration file.
        
    exec { "/home/${name}/.config/lxterminal/lxterminal.conf":
            command => "/bin/chown ${name}:${name} /home/${name}/.config/lxterminal/lxterminal.conf",
          subscribe => File["/home/${name}/.config/lxterminal"],
        refreshonly => true,
    }

}