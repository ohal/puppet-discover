# 0.1 memcached
# ohal@softserveinc.com
# = do check and install and configure memcached
# ubuntu and centos tested
class memcached (
  $memcached_ensure = 'present',
  # use  <num>  MB memory max to use for object storage; the default is 64 megabytes
  $memcached_cachesize = '128',
  # listen on TCP port <num>, the default is port 11211
  $memcached_port = '11211',
  # use <num> max simultaneous connections; the default is 1024.
  $memcached_connection = '1024',
  # listen on <ip_addr>; default to INADDR_ANY. This is an important
  # option  to  consider  as  there  is  no  other way to secure the
  # installation
  # binding  to  an  internal  or  firewalled  network interface is suggested
  $memcached_listen_ip = '127.0.0.1',
  # assume the identity of <username> (only when run as root)
  $memcached_user = 'nobody',
  # defaults
  $memcached_manage_install = true,
  $memcached_manage_config = true,
  $memcached_manage_service = true,
  $memcached_autoupgrade = true,
  $memcached_config_file = undef,
  $memcached_template_file = undef,
  $memcached_config_file_owner = 'root',
  $memcached_config_file_group = 'root',
  $memcached_config_file_mode = '0644',
  $memcached_package = 'memcached',
  $memcached_service_ensure = 'running',
  $memcached_service_name = 'memcached',
  $memcached_service_enable = true,
  ) {
  # set configuration file name depends on OS
  if ! $memcached_config_file {
      $memcached_config_file_real = $::osfamily ? {
        'Debian' => hiera('memcached_config_file','/etc/memcached.conf'),
        'RedHat' => hiera('memcached_config_file','/etc/sysconfig/memcached'),
        default  => hiera('memcached_config_file',undef),
        }
  } else {
      $memcached_config_file_real = $memcached_config_file
  }
  # set template file name depends on OS
  if ! $memcached_template_file {
      $memcached_template_file_real = $::osfamily ? {
        'Debian' => hiera('memcached_template_file','memcached/memcached.conf.erb'),
        'RedHat' => hiera('memcached_template_file','memcached/memcached.erb'),
        default  => hiera('memcached_template_file',undef),
        }
  } else {
      $memcached_config_file_real = $memcached_config_file
  }
  # memcached maintain
  case $memcached_ensure {
    /(present)/: {
      if $memcached_autoupgrade == true {
        $memcached_package_ensure = 'latest'
      } else {
        $memcached_package_ensure = 'present'
      }
    }
    /(absent)/: {
      $memcached_package_ensure = 'absent'
      $memcached_service_ensure = 'stopped'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }
  # dependency block always should be at the end of first class
  Class['memcached::install']-> Class['memcached::config'] -> Class['memcached::service']
  # install, configure and manage service
  include memcached::install, memcached::config, memcached::service
}