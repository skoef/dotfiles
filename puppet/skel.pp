# Documentation goes here
class skel (
  $service_name        = $skel::params::service_name,
  $package_name        = $skel::params::package_name,
  $absent              = $skel::params::absent,
  $disable             = $skel::params::disable,
  $disableboot         = $skel::params::disableboot,
  $service_autorestart = $skel::params::service_autorestart,
  $config_dir          = $skel::params::config_dir,
  $config_file         = $skel::params::config_file,
  $config_file_owner   = $skel::params::config_file_owner,
  $config_file_group   = $skel::params::config_file_group,
  $config_file_mode    = $skel::params::config_file_mode,
  $logfile             = $skel::params::logfile,
  $pidfile             = $skel::params::pidfile,
  $source              = $skel::params::source,
  $template            = $skel::params::template,
  $firewall            = $skel::params::firewall,
  $firewall_src        = $skel::params::firewall_src,
  $firewall_dst        = $skel::params::firewall_dst,
  $firewall_port       = $skel::params::firewall_port,
) inherits skel::params {

  $bool_absent              = any2bool($absent)
  $bool_disable             = any2bool($disable)
  $bool_disableboot         = any2bool($disableboot)
  $bool_service_autorestart = any2bool($service_autorestart)
  $bool_firewall            = any2bool($firewall)

  $manage_package_ensure = $skel::bool_absent ? {
    true  => 'absent',
    false => 'installed',
  }

  $manage_service_ensure = $skel::bool_disable ? {
    true    => 'stopped',
    default => $skel::bool_absent ? {
      true    => 'stopped',
      default => 'running',
    }
  }

  $manage_service_enable = $skel::bool_disableboot ? {
    true    => false,
    default => $skel::bool_disable ? {
      true    => false,
      default => $skel::bool_absent ? {
        true  => false,
        false => true,
      },
    },
  }

  $manage_service_autorestart = $skel::bool_service_autorestart ? {
    true  => "Service[skel]",
    false => undef,
  }

  $manage_file_ensure = $skel::bool_absent ? {
    true  => 'absent',
    false => 'file',
  }

  $manage_file_source = $skel::source ? {
    ''      => undef,
    default => $skel::source,
  }

  $manage_file_content = $skel::template ? {
    ''      => undef,
    default => template($skel::template),
  }

  $manage_directory_ensure = $skel::bool_absent ? {
    true  => 'absent',
    false => 'directory',
  }

  $manage_config_source = $skel::source ? {
    ''      => undef,
    undef   => undef,
    default => $skel::source,
  }

  $manage_config_content = $skel::template ? {
    ''      => undef,
    undef   => undef,
    default => template($skel::template),
  }

  package { 'skel':
    ensure => $manage_package_ensure,
    name   => $skel::package_name,
  }

  service { 'skel':
    ensure  => $manage_service_ensure,
    name    => $skel::service_name,
    enable  => $manage_service_enable,
    require => Package['skel'],
  }

  file { 'skel.conf':
    ensure  => $manage_file_ensure,
    path    => $skel::config_file,
    owner   => $skel::config_file_owner,
    group   => $skel::config_file_group,
    mode    => $skel::config_file_mode,
    source  => $manage_file_source,
    content => $manage_file_content,
    notify  => $manage_service_autorestart,
    require => Package['skel'],
  }

  if $bool_firewall == true {
    firewall::rule { 'skel-allow-in':
      protocol    => 'tcp',
      port        => $firewall_port,
      direction   => 'input',
      source      => $firewall_src,
      destination => $firewall_dst,
    }
  }
}
