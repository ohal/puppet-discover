class svarog::config {
  # If svarog_manage_config = false then do nothing.
  # For better resolving dependencies cycles.
  if str2bool("$svarog::svarog_manage_config") {
    file { $svarog::svarog_config_dir:
      ensure  => $svarog::svarog_ensure_dir,
      owner   => $svarog::svarog_config_owner,
      group   => $svarog::svarog_config_group,
      mode    => $svarog::svarog_config_settings_dir_mode,
    }
    file { $svarog::svarog_config_settings_dir:
      ensure  => $svarog::svarog_ensure_dir,
      owner   => $svarog::svarog_config_owner,
      group   => $svarog::svarog_config_group,
      mode    => $svarog::svarog_config_settings_dir_mode,
    }
    file { $svarog::svarog_config_dummy_dir:
      ensure  => $svarog::svarog_ensure_dir,
      owner   => $svarog::svarog_config_owner,
      group   => $svarog::svarog_config_group,
      mode    => $svarog::svarog_config_dummy_dir_mode,
    }
    file { $svarog::svarog_config_repo:
      ensure  => $svarog::svarog_ensure,
      owner   => $svarog::svarog_config_owner,
      group   => $svarog::svarog_config_group,
      mode    => $svarog::svarog_config_repo_mode,
      content => template('svarog/local.repo.erb'),
    }
    file { $svarog::svarog_config_settings:
      ensure  => $svarog::svarog_ensure,
      owner   => $svarog::svarog_config_owner,
      group   => $svarog::svarog_config_group,
      mode    => $svarog::svarog_config_settings_mode,
      content => template('svarog/settings.sh.erb'),
    }
    file { $svarog::svarog_config_dummy:
      ensure  => $svarog::svarog_ensure,
      owner   => $svarog::svarog_config_owner,
      group   => $svarog::svarog_config_group,
      mode    => $svarog::svarog_config_dummy_mode,
      content => template('svarog/ssof-dummy-settings.sh.erb'),
    }
  }
}
