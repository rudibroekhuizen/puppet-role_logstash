# == Class: role_logstash::patternfile
#
class role_logstash::patternfile {

  create_resources( 'logstash::patternfile', $role_logstash::patternfile_hash )
  
}
