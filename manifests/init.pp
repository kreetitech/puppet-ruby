class ruby($version = '1.9.2-p318') {
   Exec { path => [ '/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'],
     logoutput => true,}

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
      creates   => "/usr/local/src/tar-${version}",
      alias     => "untar-ruby-source",
      subscribe => Exec["ruby-source-tgz"]
    }

    exec { "bash configure":
      cwd     => "/usr/local/src/ruby-${version}",
      require => [Exec["untar-ruby-source"], Class['ruby::dependencies']],
      creates => "/usr/local/src/ruby-${version}/config.h",
      before  => Exec["make install"],
    }

    exec { "make && make install":
      cwd     => "/usr/local/src/ruby-${version}",
      alias   => "make install",
      creates => [ "/usr/local/src/ruby-${version}/ruby",
                   "/usr/local/bin/ruby" ],
      require => Exec["./configure"],
    }
}
