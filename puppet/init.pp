# skel class
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
  $log_file            = $skel::params::log_file,
  $pid_file            = $skel::params::pid_file,
  $source              = $skel::params::source,
  $template            = $skel::params::template,
  $firewall            = $skel::params::firewall,
  $firewall_src        = $skel::params::firewall_src,
  $firewall_dst        = $skel::params::firewall_dst,
  $firewall_port       = $skel::params::firewall_port,
  $debug               = $skel::params::debug,
  $my_class            = $skel::params::my_class,
) inherits skel::params {

  $bool_absent              = str2bool($absent)
  $bool_disable             = str2bool($disable)
  $bool_disableboot         = str2bool($disableboot)
  $bool_service_autorestart = str2bool($service_autorestart)
  $bool_firewall            = str2bool($firewall)
  $bool_debug               = str2bool($debug)

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
    true  => 'Service[skel]',
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

  $manage_firewall_enable = $skel::bool_absent ? {
    true  => false,
    false => $skel::bool_disable ? {
      true  => false,
      false => $skel::bool_firewall,
    }
  }

  $manage_debug_ensure = $skel::bool_absent ? {
    true  => 'absent',
    false => $skel::bool_debug ? {
      false => 'absent',
      true  => 'file',
    }
  }

  if $skel::my_class != '' {
    include $skel::my_class
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

  firewall::rule { 'skel-allow-in':
    protocol    => 'tcp',
    port        => $firewall_port,
    direction   => 'input',
    source      => $firewall_src,
    destination => $firewall_dst,
    enable      => $manage_firewall_enable,
  }

  file { 'debug_skel':
    ensure  => $skel::manage_debug_ensure,
    path    => "${::puppet_vardir}/debug-skel",
    mode    => '0640',
    owner   => 'root',
    content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
  }
}
