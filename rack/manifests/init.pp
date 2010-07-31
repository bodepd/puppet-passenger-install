class rack {
  package{'rack':
    ensure => $rack_version,
    provider => 'gem',
  }
}
