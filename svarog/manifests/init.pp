# 0.1 svarog 12/04/2013
# ohal@softserveinc.com
# install and configure svarog build/repo server
# centos 6 tested
class svarog (
  # defaults
  $svarog_ensure = 'present',
  $svarog_autoupgrade = true,
  $svarog_packages = undef,
  $svarog_manage_install = true,
  $svarog_manage_config = true,
  $svarog_config_file = '/etc/yum.repos.d/local.repo',
  $svarog_config_file_owner = 'root',
  $svarog_config_file_group = 'root',
  $svarog_config_file_mode = '0644',
  # local repository url
  $svarog_repo_url = 'http://192.168.153.38/repo/',
    ) {
  # set svarog packages list
  if ! $svarog_packages {
    case $osfamily {
      'RedHat': {
        $svarog_packages_real = hiera('svarog_packages',
          ['svarog.noarch','svarog-ci.noarch','svarog-repo.noarch'])
      }
      default : {
        fail("the ${module_name} module is not supported on ${osfamily}")
      }
    }
  } else {
      $svarog_packages_real = $svarog_packages
  }
  # svarog maintaining
  case $svarog_ensure {
    /(present)/: {
      if $svarog_autoupgrade == true {
        $svarog_package_ensure = 'latest'
      } else {
        $svarog_package_ensure = 'present'
      }
    }
    /(absent)/: {
      $svarog_package_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }
  # dependency block always should be at the end of first class
  Class['svarog::config']-> Class['svarog::install']
  # configure and install service
  include svarog::config, svarog::install
}