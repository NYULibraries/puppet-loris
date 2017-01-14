require 'spec_helper'
describe 'loris' do

  context 'with defaults for all parameters' do
    it { should contain_class('loris') }
  end
end
