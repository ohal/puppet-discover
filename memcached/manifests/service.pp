class memcached::service {
  # If ssh_manage_service = false then do nothing.
  # For better resolving dependencies cycles.
  if str2bool("$memcached::memcached_manage_service") {
    service { $memcached::memcached_service_name:
      ensure     => $memcached::memcached_service_ensure,
      enable     => $memcached::memcached_service_enable,
    }
  }
}
