# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include skel::install
class skel::install {
  include skel

  $manage_package_ensure = $skel::absent ? {
    true  => absent,
    false => $skel::package_version,
  }

  package { 'skel':
    ensure => $manage_package_ensure,
    name   => $skel::package_name,
  }
}
