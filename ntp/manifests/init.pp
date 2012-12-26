class ntp (
  $ntp_server_list      = 'ntp.ubuntu.com',
  $ntp_server_enabled   = true,
  $ntp_query_networks   = [],
  $ntp_interface_ignore = [],
  $ntp_interface_listen = [],
  $ntp_enable_statistics = true,
  $ntp_statsdir = '/tmp',
  $ntp_config_file = '/etc/ntp.conf',
  $ntp_config_file_owner = 'root',
  $ntp_config_file_group = 'root',
  $ntp_config_file_mode = '0644',
  $ntp_driftfile = undef,
  $ntp_ensure = 'present',
  $ntp_autoupgrade = true,
  $ntp_package = 'ntp',
  $ntp_service_ensure = 'running',
  $ntp_service_name = undef,
  $ntp_service_enable = true,
  $ntp_manage_install = true,
  $ntp_manage_config = true,
  $ntp_manage_service = true,
) {

  if ! $ntp_service_name {
    $ntp_service_name_real = $::osfamily ? {
                        'Debian' => hiera('ntp_service_name','ntp'),
                        'RedHat' => hiera('ntp_service_name','ntpd'),
                        default  => hiera('ntp_service_name',undef),
                    }
  } else {
   $ntp_service_name_real = $ntp_service_name
  }

  case $ntp_ensure {
    /(present)/: {
      if $ntp_autoupgrade == true {
        $ntp_package_ensure = 'latest'
      } else {
        $ntp_package_ensure = 'present'
      }

      if $ntp_server_enabled == false {
        $ntp_interface_ignore_real = [ 'all', ]
        $ntp_interface_listen_real = [ 'lo', ]
      } elsif $ntp_server_enabled == true {
        $ntp_interface_ignore_real = $ntp_interface_ignore
        $ntp_interface_listen_real = $ntp_interface_listen
      } else {
        fail('server_enabled parameter must be true or false')
      }

      if $ntp_enable_statistics == true {
        if ! $ntp_driftfile {
          $ntp_driftfile_real = $::osfamily ? {
                         'Debian' => hiera('ntp_driftfile','/var/lib/ntp/ntp.drift'),
                         'RedHat' => hiera('ntp_driftfile','/var/lib/ntp/drift'),
                         default  => hiera('ntp_driftfile',undef),
                       }
        } else {
          $ntp_driftfile_real = $ntp_driftfile
        }
        if ! $ntp_statsdir {
          fail('statsdir parameter must be set, if enable_statistics is true')
        }
      }
    }
    /(absent)/: {
      $ntp_package_ensure = 'absent'
      $ntp_service_ensure = 'stopped'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }
  
  # Dependency block. Always should be at the end of first class.
  Class['ntp::install']-> Class['ntp::config'] -> Class['ntp::service']
  include ntp::install, ntp::config, ntp::service
}