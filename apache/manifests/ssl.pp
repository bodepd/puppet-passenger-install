# Class: apache::ssl
#
# This class installs Apache SSL capabilities
#
# Parameters:
# - The $ssl_package name from the apache::params class
#
# Actions:
#   - Install Apache SSL capabilities
#
# Requires:
#
# Sample Usage:
#
class apache::ssl {

  include apache
  
  case $operatingsystem {
     'centos', 'fedora', 'redhat': {
        package { $apache::params::ssl_package:
           require => Package['httpd'],
        }
        # I don't want this purged.
        file { "${apache::params::vdir}/ssl.conf":
          ensure => present,
          require => Package[$apache::params::ssl_package],
        }
     }
     'ubuntu', 'debian': {
        a2mod { "ssl": ensure => present, }
     }
  }
}
