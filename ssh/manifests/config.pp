class ssh::config {
  # If ssh_manage_config = false then do nothing.
  # For better resolving dependencies cycles.
  if str2bool("$ssh::ssh_manage_config") {
    file { $ssh::ssh_config_file:
      ensure  => $ssh::ssh_ensure,
      owner   => $ssh::ssh_config_file_owner,
      group   => $ssh::ssh_config_file_group,
      mode    => $ssh::ssh_config_file_mode,
      content => template('ssh/sshd_config.erb'),
      notify  => Class['ssh::service'],
    }
  }
}
