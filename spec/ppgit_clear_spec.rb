require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "`ppgit clear`" do

  context "when NONE of the [user] nor the ppgit variables are stored in the 2 config files"  do
    before(:all) do
      @before_local    = [ '[user]'               ,
                            '[user-before-ppgit]'  ]
      @before_global   = [ '[ppgit]' ]
      @actual_local, @actual_global = execute_command_g( ppgit("clear"), @before_local, @before_global)
    end
    it("removes the empty [user-before-ppgit] section from .git/config" ) do
      expected_local = [ '[user]']
      @actual_local.should == expected_local.join("\n")
    end
    it("doesn't change ~/.gitconfig") { @actual_global.should == @before_global.join("\n") }
  end


  context 'when there is a user.name and a user.email but no backed-up values' do
    before(:all) do
      @before_local    = [  '[user]'                          ,
                            '  name = Alain Ravet'            ,
                            '  email = alainravet@gmail.com'  ]
      @before_global   = []
      @actual_local, @actual_global = execute_command_g( ppgit("clear"), @before_local, @before_global)
    end

    it("doesn't change .git/config" ) { @actual_local .should == @before_local .join("\n") }
    it("doesn't change ~/.gitconfig") { @actual_global.should == @before_global.join("\n") }
  end


  context 'when there is a user.name + email AND stored values in user-before-ppgit AND an emailroot' do
    before(:all) do
      @before_local   = [  '[user]'                        ,
                            '  name = andy_john'            ,  # value to replace
                            '  email = andy_john@test.com'  ,  #  ..

                            '[user-before-ppgit]'             , # section to erase
                            '  name = Alain Ravet'            , # value to restore
                            '  email = alainravet@gmail.com'  ] #   ..
      @before_global  = [   '[ppgit]'                         ,
                            '  emailroot = old+*@gmail.com'  ]
      @actual_local, @actual_global, @output = execute_command_g( ppgit("clear"), @before_local, @before_global)
    end

    it('empties and removes the [user-before-ppgit] section' ) do
      expected_local= [  '[user]'                        ,
                    '  name = Alain Ravet'          , # restored value
                    '  email = alainravet@gmail.com'] #  ..

      @actual_local.should == expected_local.join("\n")
    end
    it("doesn't remove the ppgit.emailroot in ~/.gitconfig") { 
      @actual_global.should == @before_global.join("\n")
    }
    it "displays the ppgit info" do
      pending 'till we find a better way to fake the file system'
      @output.should match(/.*\[ppgit\].*emailroot.*/mi)
    end
  end
end
