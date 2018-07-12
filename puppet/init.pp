# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include skel
class skel (
  Boolean              $absent                  = false,
  Boolean              $disableboot             = false,
  String               $service_name            = $skel::params::service_name,
  Boolean              $service_autorestart     = $skel::params::service_autorestart,
  String               $package_name            = $skel::params::package_name,
  String               $package_version         = $skel::params::package_version,
  Stdlib::Absolutepath $config_file             = $skel::params::config_file,
  Stdlib::Absolutepath $config_dir              = $skel::params::config_dir,
  String               $source                  = $skel::params::source,
  String               $template                = $skel::params::template,
  Hash                 $options                 = {},
) inherits skel::params {

  $real_options = merge($skel::params::defaults, $options)

  contain skel::install
  contain skel::config
  contain skel::service

  Class['skel::install']
  -> Class['skel::config']
  ~> Class['skel::service']
}
