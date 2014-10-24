#
class skel::params {
  $config_dir = $::operatingsystem ? {
    /(?i:FreeBSD)/ => '/usr/local/etc/skel',
  }

  $config_file = $::operatingsystem ? {
    /(?i:FreeBSD)/ => '/usr/local/etc/skel/skel.conf',
  }

  $config_file_owner   = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group   = $::operatingsystem ? {
    /(?i:FreeBSD)/ => 'wheel',
    default        => 'root',
  }

  $pidfile = $::operatingsystem ? {
    /(?i:FreeBSD)/ => '/var/run/skel.pid',
  }

  $package_name = $::operatingsystem ? {
    /(?i:FreeBSD)/ => 'dummy/skel',
  }

  $service_name = $::operatingsystem ? {
    /(?i:FreeBSD)/ => 'skel',
  }

  $absent              = false
  $disable             = false
  $disableboot         = false
  $service_autorestart = true
  $config_file_mode    = '0644'
  $source              = ''
  $template            = ''
  $firewall            = false
  $firewall_src        = ['0.0.0.0', '::/0']
  $firewall_dst        = ['0.0.0.0', '::/0']
  $firewall_port       = 0
}
