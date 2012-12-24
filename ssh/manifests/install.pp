class ssh::install {
  # If ssh_manage_install = false then do nothing.
  # For better resolving dependencies cycles.
  if str2bool("$ssh::ssh_manage_install") {
    package { $ssh::ssh_packages_real:
        ensure => $ssh::ssh_package_ensure,
    }
  }
}
