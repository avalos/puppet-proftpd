
class proftpd {
   file { proftpd-preseed:
     path => "/var/cache/debconf/proftpd",
     owner => root, group => root, mode => 400,
     source => "$filesrv/files/proftpd/proftpd.preseed"
   }
	package { proftpd:
		name   => $operatingsystem ? {
			default	=> "proftpd",
			},
		ensure => present,
       responsefile => "/var/cache/debconf/proftpd.preseed",
       require => File[proftpd-preseed]
	}

	service { proftpd:
		name => $operatingsystem ? {
                        default => "proftpd",
                        },
		ensure => running, enable => true,
		hasrestart => true, hasstatus => true,
		require => Package["proftpd"],
                subscribe => [File["proftpd-conf"], File["proftpd-pam"]],
	}

	file {	
             	"proftpd-conf":
			mode => 644, owner => root, group => root,
			require => Package[proftpd],
			ensure => present,
			path => $operatingsystem ?{
                        	default => "/etc/proftpd/proftpd.conf",
                        },
                        source => "$filesrv/files/proftpd/proftpd.conf",
	}

	file {	
             	"proftpd-pam":
			mode => 644, owner => root, group => root,
			ensure => present,
			path => $operatingsystem ?{
                        	default => "/etc/pam.d/proftpd",
                        },
                        source => "$filesrv/files/empty",
	}
}
