# == Class: role_logstash
#
# Full description of class role_logstash here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { role_logstash:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class role_logstash(
  $package_url  = 'https://artifacts.elastic.co/downloads/logstash/logstash-5.1.1.deb',
  $configfile   = 'logstash-generator-01.conf',
  $config_hash  = { 'LS_HEAP_SIZE' => '200m',
                    'LS_USER'      => 'root', # Use root here, not logstash user. With logstash user syslog files cannot be read, permission denied.
                  },
  $patternfiles = ["openstack.grok", "pfsense.grok", "snmp.grok"]
  ) {

  # Install Java
  include java

  # Install logstash
  class { 'logstash':
    package_url   => $package_url,
    init_defaults => $config_hash,
  }

  # Load logstash filter, will be renamed to /etc/logstash/conf.d/logstash.conf
  logstash::configfile { $configfile:
    source => "puppet:///modules/role_logstash/${configfile}",
  }

  # Add custom pattern files (Puppet 4 style)
  $patternfiles.each |String $patternfile| {
    logstash::patternfile { $patternfile:
      source => "puppet:///modules/role_logstash/$patternfile"
    }
  }
  
  #logstash::plugin { 'logstash-input-beats': }
  
}
