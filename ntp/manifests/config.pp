class ntp::config {
  # If ntp_manage_config = false then do nothing.
  # For better resolving dependencies cycles.
  if str2bool("$ntp::ntp_manage_config") {
	  file { $ntp::ntp_config_file:
			ensure  => $ntp::ntp_ensure,
			owner   => $ntp::ntp_config_file_owner,
			group   => $ntp::ntp_config_file_group,
			mode    => $ntp::ntp_config_file_mode,
			content => template('ntp/ntp.conf.erb'),
			notify  => Class['ntp::service'],
	  }
  }
}
