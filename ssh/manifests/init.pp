# 0.1 openssh is manipulate by puppet
# ohal@softserveinc.com
# = do check and install and configure openssh server and client
# ubuntu and centos tested
class ssh (
  $ssh_ensure = 'present',
  # port is open for external connection to openssh server
  $ssh_port = '22',
  # ssh protocol
  $ssh_protocol = '2',
  # openssh server is listen from ip addresses
  $ssh_listen_address = [],
  # privilege separation
  $ssh_privilege_separation = 'yes',
  # loglevel - the possible values are: 
  # QUIET, FATAL, ERROR, INFO, VERBOSE, DEBUG, DEBUG1, DEBUG2, and DEBUG3
  # default is INFO.
  $ssh_loglevel = 'INFO',
  # server disconnects after this time in seconds
  $ssh_logingracetime = '120',
  # should check file modes and ownership before accepting login
  $ssh_strictmodes = 'yes',
  # root connections restriction
  $ssh_root_login = 'yes',
  # clear password restriction
  $ssh_password_authentication = 'no',
  # users what allowed to connect to openssh server
  $ssh_users = [],
  # specifies whether pure RSA authentication is allowed
  $ssh_rsa_authentication = 'yes',
  # specifies whether public key authentication is allowed
  $ssh_pubkey_authentication = 'yes',
  # specifies that .rhosts and .shosts files will not be used
  $ssh_ignore_rhosts = 'yes',
  # specifies whether rhosts or /etc/hosts.equiv authentication together
  # with successful RSA host authentication is allowed
  $ssh_rhostsrsa_authentication = 'no',
  # specifies whether rhosts or /etc/hosts.equiv authentication
  # together with successful public key client host authentication is
  # allowed (host-based authentication)
  # protocol version 2 only
  $ssh_hostbased_authentication = 'no',
  # specifies whether should ignore the user's ~/.ssh/known_hosts
  $ssh_ignore_user_known_hosts = 'no',
  # specifies whether challenge-response authentication is allowed
  $ssh_challenge_response_authentication = 'yes',
  # to enable empty passwords change to yes (NOT RECOMMENDED)
  $ssh_empty_password = 'no',
  # defaults
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
  # set service name depends on OS
  if ! $ssh_service_name {
      $ssh_service_name_real = $::osfamily ? {
        'Debian' => hiera('ssh_service_name','ssh'),
        'RedHat' => hiera('ssh_service_name','sshd'),
         default => hiera('ssh_service_name',undef),
        }
  } else {
      $ssh_service_name_real = $ssh_service_name
  }
  # set packages list depends on OS
  if ! $ssh_packages {
    case $osfamily {
      'Debian': {
        $ssh_packages_real = hiera('ssh_packages',
          ['ssh','openssh-client','openssh-server'])
      }
      'RedHat': {
        $ssh_packages_real = hiera('ssh_packages',
          ['openssh','openssh-clients','openssh-server'])
      }
      default : {
#        $ssh_packages_real = hiera('ssh_packages',undef)
#        notify { "${module_name}_unsupported":
#          message => "the ${module_name} module is not supported on ${osfamily}",
#        }
        fail("the ${module_name} module is not supported on ${osfamily}, must be set =ssh_packages=")
      }
    }
#      $ssh_packages_real = $::osfamily ? {
#          'Debian' => hiera('ssh_packages',
#                        ['ssh','openssh-client','openssh-server']),
#          'RedHat' => hiera('ssh_packages',
#                        ['openssh','openssh-clients','openssh-server']),
#           default => hiera('ssh_packages',undef),
#      }
  } else {
      $ssh_packages_real = $ssh_packages
  }
  # ssh maintaining
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
  # dependency block always should be at the end of first class
  Class['ssh::install']-> Class['ssh::config'] -> Class['ssh::service']
  # install, configure and manage service
  include ssh::install, ssh::config, ssh::service
}