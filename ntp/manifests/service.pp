class ntp::service {
  # If ntp_manage_service = false then do nothing.
  # For better resolving dependencies cycles.
  if str2bool("$ntp::ntp_manage_service") {
	  service { $ntp::ntp_service_name_real:
	    ensure     => $ntp::ntp_service_ensure,
	    enable     => $ntp::ntp_service_enable,
	  }
  }
}
