class ruby($version = '1.9.2-p318') {
   Exec { path => [ '/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'],
     logoutput => true,}

   class {'ruby::dependencies':}
   file { "/usr/local/src":
     ensure => directory }

    exec { "wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-${version}.tar.gz":
      alias => "ruby-source-tgz",
      cwd       => "/usr/local/src",
      creates   => "/usr/local/src/ruby-${version}.tar.gz",
      before => Exec["untar-ruby-source"],
    }

    exec { "tar xzf ruby-${version}.tar.gz":
      cwd       => "/usr/local/src",
      creates   => "/usr/local/src/ruby-${version}",
      alias     => "untar-ruby-source",
      subscribe => Exec["ruby-source-tgz"],
      notify    => Exec["configure-ruby"],
    }

    exec { "bash configure":
      cwd     => "/usr/local/src/ruby-${version}",
      require => [Exec["untar-ruby-source"], Class['ruby::dependencies']],
      alias   => 'configure-ruby',
      refreshonly => true,
      creates => "/usr/local/src/ruby-${version}/config.h",
      before  => Exec["make-install"],
      notify    => Exec["make-install"],
    }

    exec { "make && make install":
      cwd     => "/usr/local/src/ruby-${version}",
      alias   => "make-install",
      creates => "/usr/local/bin/ruby",
      require => Exec["configure-ruby"],
      notify    => Exec["gem-update"],
    }

    exec { "gem update --system":
      cwd     => "/usr/local/src/ruby-${version}",
      alias   => "gem-update",
      refreshonly => true,
      require => Exec["make-install"],
      notify    => Exec["gem-install-bundler"],
    }

    exec { "gem install bundler":
      cwd     => "/usr/local/src/ruby-${version}",
      alias   => "gem-install-bundler",
      creates => "/usr/local/bin/bundle",
      require => Exec["make-install"],
    }
}
