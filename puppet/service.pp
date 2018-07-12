# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include skel::service
class skel::service {
  include skel

  $manage_service_enable = !($skel::disableboot or $skel::absent)
  $manage_service_ensure = $skel::absent ? {
    true  => 'stopped',
    false => 'running',
  }

  service { 'skel':
    ensure     => $manage_service_ensure,
    name       => $skel::service_name,
    enable     => $manage_service_enable,
    hasrestart => true,
    require    => Package['skel'],
  }
}
