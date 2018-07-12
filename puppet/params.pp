# skel defaults
class skel::params {
  $service_name            = 'skel'
  $service_autorestart     = true
  $package_name            = 'skel'
  $package_version         = 'present'
  $config_file             = '/etc/skel.cfg'
  $config_dir              = '/etc/skel.d'
  $source                  = undef
  $template                = 'skel/skel.cfg.epp'

  # unconfigurable
  $defaults = {
  }
}
