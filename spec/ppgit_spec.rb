require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ppgit john andy" do

  context 'when there is no user name nor email nor ppgit.email.root in the config' do
    before(:each) do
      @actual = temp_from_model('empty_before')
      `#{PPGIT_CMD} john andy --files #{@actual.path}`
    end
    
    it "appends the pair user" do
      assert_same_contents(@actual, 'empty_after_ppgit_john_andy')
    end
  end
end
