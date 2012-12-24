class ssh::service {
  # If ssh_manage_service = false then do nothing.
  # For better resolving dependencies cycles.
  if str2bool("$ssh::ssh_manage_service") {
	  service { $ssh::ssh_service_name_real:
	    ensure     => $ssh::ssh_service_ensure,
	    enable     => $ssh::ssh_service_enable,
	  }
  }
}
