require 'spec_helper'
describe 'role_logstash' do

  context 'with defaults for all parameters' do
    it { should contain_class('role_logstash') }
  end
end
