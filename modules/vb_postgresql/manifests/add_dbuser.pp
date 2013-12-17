#
# Manage PostgreSQL-9.1
#
# Sample usage: vb_postgresql::add_dbuser { 'bekr' : }
#
#
define vb_postgresql::add_dbuser {

	
	include vb_postgresql
		
	# add one database user
	
	exec { "create_postgres_user":
		command => "/bin/su - postgres && /usr/bin/createuser $name --createdb --no-superuser --no-password --no-createrole && /bin/sh exit",
		require => Class["vb_postgresql"],
		notify => Exec["set_mode_password_file"],
	}	
	
	# although the user password may not be in use, it should always have mode '0600'
	
    exec { "set_mode_password_file" :
         command => "/bin/chmod 0600 /home/$name/.pgpass",    
    }
	
	
    
}