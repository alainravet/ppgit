require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "`ppgit john andy`" do

  context 'when there is no user name nor email nor ppgit.email.root in the config' do
    before = [
      '[a]'                 ,
    ]
    expected = [
      '[a]'                 ,
      '[user]'              ,
      '  name = andy_john'  ,
    ]

    it "combines the names alphabetically and stores them a the new user.name" do
      cmd = "#{PPGIT_CMD} john andy"
      check_command_result(cmd, before, expected)
    end
  end

end
