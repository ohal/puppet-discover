class svarog::install {
  # If svarog_manage_install = false then do nothing.
  # For better resolving dependencies cycles.
  if str2bool("$svarog::svarog_manage_install") {
    package { $svarog::svarog_packages_real:
        ensure => $svarog::svarog_package_ensure,
    }
  }
}
