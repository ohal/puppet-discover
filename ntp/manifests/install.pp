class ntp::install {
  # If ntp_manage_install = false then do nothing.
  # For better resolving dependencies cycles.
  if str2bool("$ntp::ntp_manage_install") {
	  package { $ntp::ntp_package:
	    ensure => $ntp::ntp_package_ensure,
	  }
  }
}
