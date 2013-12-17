#
# Manage PostgreSQL-9.1
#
# Sample usage: vb_postgresql::create_database { 'jensen' : $owner => 'bekr' }
#
#
define vb_postgresql::create_database ( $owner='' ) {


    include vb_postgresql

	if $owner == '' {
		fail("FAIL: Missing the owner of the new $name PostgreSQL database. Owner name must be defined!")
	}

	# add new postgres database and owner
	
	exec { "create_postgres_database_and_owner":
		command => "/bin/su - postgres && /usr/bin/createdb -O $owner $name && /bin/sh exit",
		require => Class["vb_postgresql"],
	}	
	
    
}