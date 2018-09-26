# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include skel::config
class skel::config {
  include skel

  $manage_file_ensure = $skel::absent ? {
    true  => absent,
    false => file,
  }

  $manage_file_source = $skel::source ? {
    undef   => undef,
    default => $skel::source,
  }

  $manage_file_content = $skel::template ? {
    undef   => undef,
    default => epp($skel::template, {

    }),
  }

  $manage_file_notify = $skel::service_autorestart ? {
    true  => Service['skel'],
    false => undef,
  }

  $manage_directory_ensure = $skel::absent ? {
    true  => absent,
    false => directory,
  }

  file { 'skel.cfg':
    ensure  => $manage_file_ensure,
    path    => $skel::config_file,
    owner   => 'root',
    group   => $facts['root_group'],
    mode    => '0644',
    source  => $manage_file_source,
    content => $manage_file_content,
    notify  => $manage_file_notify,
  }

  file { 'skel.cfg.d':
    ensure  => $manage_directory_ensure,
    path    => $skel::config_dir,
    owner   => 'root',
    group   => $facts['root_group'],
    mode    => '0755',
    recurse => true,
    purge   => true,
  }
}
