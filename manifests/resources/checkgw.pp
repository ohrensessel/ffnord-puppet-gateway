class ffnord::resources::checkgw (
  $gw_vpn_interface  = "tun-anonvpn", # Interface name for the anonymous vpn
  $gw_control_ip     = "8.8.8.8",     # Control ip addr
  $gw_bandwidth      = 54,            # How much bandwith we should have up/down per mesh interface
  $gw_local_ip = "10.112.42.1",                      # a private ip of the gateway
) {

  file {
    '/usr/local/bin/check-gateway':
      ensure => file,
      mode => "0755",
      source => 'puppet:///modules/ffnord/usr/local/bin/check-gateway';
  }

  ffnord::resources::ffnord::field {
    "GW_VPN_INTERFACE": value => "${gw_vpn_interface}";
    "GW_CONTROL_IP": value => "${gw_control_ip}";
    "GW_LOCAL_IP": value => "${gw_local_ip}";
  }

  cron {
   'check-gateway':
     command => '/usr/local/bin/check-gateway',
     user    => root,
     minute  => '*';
  }
}
