class uweweb {
	#
	# Apache + PHP + config
	#
	package{'php': 
	  ensure => installed,
	  allow_virtual => false,
	}
	package{'httpd': 
	  ensure => installed,
	  allow_virtual => false,
	}
	file{'uwe-conf-d':
	  path => '/etc/httpd/conf.d/uwe-carstens.de.conf',
	  source => 'puppet:///modules/uweweb/uwe-carstens.de.conf',
	  ensure => present,
	  require => Package['httpd'],
	}
	service{'httpd':
	  ensure => running,
	  require => [ Package['php'], File['uwe-conf-d'] ],
	  subscribe => File['uwe-conf-d'],
	}

	#
	# FTP server + config
	#
	package{'vsftpd': 
	  ensure => installed,
	  allow_virtual => false,
	}
	file{'/etc/vsftpd/vsftpd.conf':
	  ensure => present,
	  source => 'puppet:///modules/uweweb/vsftpd.conf',
	}
	service{'vsftpd':
	  ensure => running,
	  require => File['/etc/vsftpd/vsftpd.conf'],
	  subscribe => File['/etc/vsftpd/vsftpd.conf'],
	}
	  
	#
	# user uwe
	#
	user{'uwe':
	  ensure => present,
	  home => '/home/uwe',
	  managehome => true,
	  password => '$6$P2NE.ut1$19U2Mts60B3xy7aS5ietH7MnahqWrrKL5Uv0ue0CmQjKpY9JQhiGQKe3MmhA.hNj3njw4ihICpLxTD83vPc/1/',
	  shell => '/bin/bash',
	}
	file{'uwe_public_html':
	  path => '/home/uwe/public_html',
	  ensure => directory,
	  owner => 'uwe',
	  group => 'uwe',
          mode => '0755',
	  require => File['/home/uwe'],
	}
        file{'/home/uwe':
          ensure => directory,
          mode => '0755',
          require => User['uwe'],
        }
}
