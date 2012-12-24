class ssh (
  $ssh_ensure = 'present',
  $ssh_port = '22',
  $ssh_listen_address = ['192.168.0.0'],
  #,'10.1.1.0'],
  $ssh_root_login = 'yes',
  $ssh_users = ['root'],
  $ssh_manage_install = true,
  $ssh_manage_config = true,
  $ssh_manage_service = true,
  $ssh_autoupgrade = true,
  $ssh_config_file = '/etc/ssh/sshd_config',
  $ssh_config_file_owner = 'root',
  $ssh_config_file_group = 'root',
  $ssh_config_file_mode = '0600',
  $ssh_packages = undef,
  $ssh_service_ensure = 'running',
  $ssh_service_name = undef,
  $ssh_service_enable = true,
 ) {

  if ! $ssh_service_name {
    $ssh_service_name_real = $::osfamily ? {
                        'Debian' => hiera('ssh_service_name','ssh'),
                        'RedHat' => hiera('ssh_service_name','sshd'),
                        default  => hiera('ssh_service_name',undef),
                    }
  } else {
   $ssh_service_name_real = $ssh_service_name
  }

  if ! $ssh_packages {
    $ssh_packages_real = $::osfamily ? {
                        'Debian' => hiera('ssh_packages',['ssh','openssh-client','openssh-server']),
                        'RedHat' => hiera('ssh_packages',['openssh','openssh-clients','openssh-server']),
                        default  => hiera('ssh_packages',undef),
                    }
  } else {
   $ssh_packages_real = $ssh_packages
  }

  case $ssh_ensure {
    /(present)/: {
      if $ssh_autoupgrade == true {
        $ssh_package_ensure = 'latest'
      } else {
        $ssh_package_ensure = 'present'
      }
    }
    /(absent)/: {
      $ssh_package_ensure = 'absent'
      $ssh_service_ensure = 'stopped'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }
  
  # Dependency block. Always should be at the end of first class.
  Class['ssh::install']-> Class['ssh::config'] -> Class['ssh::service']
  include ssh::install, ssh::config, ssh::service
}