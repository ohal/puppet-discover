class memcached::config {
  # If ssh_manage_config = false then do nothing.
  # For better resolving dependencies cycles.
  if str2bool("$memcached::memcached_manage_config") {
    file { $memcached::memcached_config_file_real:
      ensure  => $memcached::memcached_ensure,
      owner   => $memcached::memcached_config_file_owner,
      group   => $memcached::memcached_config_file_group,
      mode    => $memcached::memcached_config_file_mode,
      content => template($memcached::memcached_template_file_real),
      notify  => Class['memcached::service'],
    }
  }
}
