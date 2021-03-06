# Class: apache
#
# This class installs Apache
#
# Parameters:
#
# Actions:
#   - Install Apache
#   - Manage Apache service
#
# Requires:
#
# Sample Usage:
#
class apache {
  include apache::params
  package { 'httpd': 
    name   => $apache::params::apache_name,
    ensure => present,
  }
  service { 'httpd':
    name      => $apache::params::apache_name,
    ensure    => running,
    enable    => true,
    subscribe => Package['httpd'],
    hasstatus => true,
    hasrestart => true,
  }
  #
  # May want to purge all none realize modules using the resources resource type.
  #
  A2mod { require => Package['httpd'], notify => Service['httpd']}
  @a2mod {
   'rewrite' : ensure => present;
   'headers' : ensure => present;
   'expires' : ensure => present;
  }
  
  
  file { $apache::params::vdir:
    ensure => directory,
    recurse => true,
    purge => true,
    notify => Service['httpd'],
    require => Package['httpd'],
  } 

  file { $apache::params::conf_file:
    owner => 'apache',
    group => 'apache',
    mode => '0644',
    source => 'puppet:///modules/apache/httpd.conf',
    notify => Service['httpd'],
    require => Package['httpd'],
  }
}
