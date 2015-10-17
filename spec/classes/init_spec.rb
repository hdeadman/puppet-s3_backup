require 'spec_helper'
describe 's3_backup' do

  context 'with defaults for all parameters' do
    it { should contain_class('s3_backup') }
  end
end
