class ffnord::named () {
  package { 
    'bind9':
      ensure => installed;
  }

  service {
    'bind9':
      ensure => running,
      enable => true,
      require => [Package['bind9'],File['/etc/bind/named.conf.options']]
  }

  file {
    '/etc/bind/named.conf.options':
      ensure  => file,
      source  => "puppet:///ffnord/etc/bind/named.conf.options",
      require => [Package['bind9']],
      notify  => [Service['bind9']];
  }
}


define ffnord::named::mesh (
  $mesh_ipv4_address,
  $mesh_ipv4_prefix,
  $mesh_ipv4_prefixlen,
  $mesh_ipv6_address,
  $mesh_ipv6_prefix,
  $mesh_ipv6_prefixlen
) {

 include ffnord::named

 $mesh_code = $name

 # Extent the listen-on and listen-on-v6 lines in the options block
 exec { "${name}_listen-on":
   command => "/bin/sed -i -r 's/(listen-on .*)\\}/\\1 ${mesh_ipv4_address};}/' /etc/bind/named.conf.options",
   require => File['/etc/bind/named.conf.options'];
 }
 
 exec { "${name}_listen-on-v6":
   command => "/bin/sed -i -r 's/(listen-on-v6 .*)\\}/\\1 ${mesh_ipv6_address};}/' /etc/bind/named.conf.options",
   require => File['/etc/bind/named.conf.options'];
 }
}