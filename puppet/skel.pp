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
  $pidfile             = $skel::params::pidfile,
  $template            = $skel::params::template,
  $firewall            = $skel::params::firewall,
  $firewall_src        = $skel::params::firewall_src,
  $firewall_dst        = $skel::params::firewall_dst,
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
    true  => "Service[${skel::service_name}]",
    false => undef,
  }

  $manage_file_ensure = $skel::bool_absent ? {
    true  => 'absent',
    false => 'file',
  }

  $manage_directory_ensure = $skel::bool_absent ? {
    true  => 'absent',
    false => 'file',
  }

  package { $skel::package_name:
    ensure => $manage_package_ensure,
  }

  service { $skel::service_name:
    ensure  => $manage_service_ensure,
    enable  => $manage_service_enable,
    require => Package[$skel::package_name],
  }

  file { 'skel.conf':
    path    => $skel::config_file,
    owner   => $skel::config_file_owner,
    group   => $skel::config_file_group,
    mode    => $skel::config_file_source,
    content => template($skel::template),
    notify  => $manage_service_autorestart,
  }
}
