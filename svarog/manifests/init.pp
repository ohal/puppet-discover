# 0.1 svarog 12/04/2013
# ohal@softserveinc.com
# install and configure svarog build/repo server
# centos 6 tested
class svarog (
  # defaults
  $svarog_ensure = 'present',
  $svarog_ensure_dir = 'directory',
  $svarog_autoupgrade = true,
  $svarog_packages = undef,
  $svarog_manage_install = true,
  $svarog_manage_config = true,
  $svarog_config_owner = 'root',
  $svarog_config_group = 'root',
  # local repository url
  $svarog_repo_url = 'http://192.168.153.38/repo/',
  $svarog_config_repo = '/etc/yum.repos.d/local.repo',
  $svarog_config_repo_mode = '0644',
  # svarog initial general conf
  $svarog_config_dir = '/etc/softserve',
  $svarog_config_settings_dir = '/etc/softserve/general',
  $svarog_config_settings_dir_mode = '755',
  $svarog_config_settings = '/etc/softserve/general/settings.sh',
  $svarog_config_settings_mode = '0755',
  $svarog_config_dummy_dir = '/etc/softserve/general/settings.d',
  $svarog_config_dummy_dir_mode = '755',
  $svarog_config_dummy = '/etc/softserve/general/settings.d/ssof-dummy-settings.sh',
  $svarog_config_dummy_mode = '0755',
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