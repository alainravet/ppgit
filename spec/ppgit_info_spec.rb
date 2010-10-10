require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "`ppgit info`" do

  context "when ALL the [user] and the ppgit variables are stored in the 2 config files"  do
    before(:all) do
      before_local    = [  '[user]'                         ,
                            '  name = andy+john'            ,
                            '  email = andy_john@test.com'  ,

                            '[user-before-ppgit]'           ,
                            '  name = John User'            ,
                            '  email = johnuser@gmail.be'   ]

      before_global   = [   '[ppgit]'                       ,
                            'namesseparator = ZEP'          ,
                            '  emailroot = acme+*@gmail.com'  ]
      ignore, ignore, @output = execute_command_g( ppgit("info"), before_local, before_global)
    end

    it('should display the [user].* info'             ) { @output.should match(/\[user\].+andy\+john.+andy_john@test.com/mi) }
    it('should display the [user-before-ppgit].* info') { @output.should match(/\[user-before-ppgit\].+John User.+johnuser@gmail.be/mi) }
    it('should display the [ppgit].emailroot info'    ) {
      @output.should match(/\[ppgit\].+emailroot\s+=\s+acme\+\*@gmail.com/mi)
    }
    it('should display the [ppgit].namesseparator info'    ) {
      @output.should match(/\[ppgit\].+namesseparator\s+=\s+ZEP/mi)
    }
  end

  context "when NONE of the [user] and the ppgit variables are stored in the config file"  do
    before(:all) do
      before_local    = [ '[user]'               ,
                          '[user-before-ppgit]'  ]
      before_global   = [ '[ppgit]' ]
      ignore, ignore, @output = execute_command_g( ppgit("info"), before_local, before_global)
    end

    it('should not display the empty [user] section'                 ) { @output.should_not match(/\[user\]/mi) }

    it('should NOT display the empty [user-before-ppgit] section') { @output.should_not match(/\[user-before-ppgit\]/mi) }
    it('should insert and display the default [ppgit].namesseparator info'    ) {
      @output.should match(/\[ppgit\].+namesseparator\s+=\s+\+/mi)
    }
  end
end
