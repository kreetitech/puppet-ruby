class ruby($version = '1.9.2-p318') {

   file { "/usr/local/src": ensure => directory }

    exec { "wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-${version}.tar.gz":
      alias => "download-ruby-source",
      cwd       => "/usr/local/src",
      creates   => "/usr/local/src/ruby-${version}.tar.gz",
      before => Exec["untar-ruby-source"],
    }

    exec { "tar xzf ruby-${version}.tar.gz":
      cwd       => "/usr/local/src",
      creates   => "/usr/local/src/tar-${version}",
      alias     => "untar-ruby-source",
      subscribe => File["ruby-source-tgz"]
    }

    exec { "./configure":
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
