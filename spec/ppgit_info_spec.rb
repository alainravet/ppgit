require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "`ppgit info`" do
  it 'should display the config details' do
    output = `#{PPGIT_CMD} info`
    output.should match(/\[user\].*\[ppgit\].*\[user-before-ppgit\]/mi)
  end
end


