class svarog::config {
  # If svarog_manage_config = false then do nothing.
  # For better resolving dependencies cycles.
  if str2bool("$svarog::svarog_manage_config") {
    file { $svarog::svarog_config_file:
      ensure  => $svarog::svarog_ensure,
      owner   => $svarog::svarog_config_file_owner,
      group   => $svarog::svarog_config_file_group,
      mode    => $svarog::svarog_config_file_mode,
      content => template('svarog/local.repo.erb'),
    }
  }
}
