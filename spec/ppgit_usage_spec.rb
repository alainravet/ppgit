require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "`ppgit`" do
  it 'should display the usage info' do
    output = `#{PPGIT_CMD}`
    output.should match(/usage/i)
  end
end
