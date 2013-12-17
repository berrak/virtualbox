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
		command => "/usr/bin/createuser $name --createdb --no-superuser --no-password --no-createrole && /bin/sh exit",
		 onlyif => "/bin/su - postgres",
		require => Class["vb_postgresql"],
	}	
	
    
}