class memcached::install {
  # If ssh_manage_install = false then do nothing.
  # For better resolving dependencies cycles.
  if str2bool("$memcached::memcached_manage_install") {
    package { $memcached::memcached_package:
        ensure => $memcached::memcached_package_ensure,
    }
  }
}
