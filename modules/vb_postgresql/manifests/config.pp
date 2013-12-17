#
# Manage PostgreSQL-9.1
#
class vb_postgresql::config {


	# setup access security to: localhost/trust all
    
    file { '/etc/postgresql/9.1/main/pg_hba.conf':
         source => "puppet:///modules/vb_postgresql/pg_hba.conf",    
          owner => 'postgres',
          group => 'postgres',
		  mode  => '0640',
        require => Class["vb_postgresql::install"],
        notify => Service["postgresql"],
    }
    
}