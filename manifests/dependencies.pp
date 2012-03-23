class ruby::dependencies {
  case $::operatingsystem {
    centos,fedora,rhel: {
    }
    debian,ubuntu: {
      package { 'build-essential': ensure => present }
      package { 'libssl-dev': ensure => present }
      package { 'bison': ensure => present }
      package { 'libreadline6-dev': ensure => present }
      package { 'zlib1g-dev': ensure => present }
      package { 'libyaml-dev': ensure => present }
      package { 'libxml2-dev': ensure => present }
    }
    opensuse,suse: {
    }
  }
}
