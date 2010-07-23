require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "`ppgit info`" do

  context "when ALL the [user] and the ppgit variables are stored in the config file"  do
    before do
      contents = [  '[user]'                        ,
                    '  name = andy_john'            ,
                    '  email = andy_john@test.com'  ,

                    '[user-before-ppgit]'           ,
                    '  name = John User'            ,
                    '  email = johnuser@gmail.be'   ,

                    '[ppgit]'                       ,
                    '  emailroot = acme+*@gmail.com',
      ]
      @output = execute_command( ppgit("info"), contents)
    end

    it('should display the [user] info'             ) { @output.should match(/\[user\].+andy_john.+andy_john@test.com/mi) }
    it('should display the [user-before-ppgit] info') { @output.should match(/\[user-before-ppgit\].+John User.+johnuser@gmail.be/mi) }
    it('should display the [ppgit] info'            ) { @output.should match(/\[ppgit\].+emailroot\s+=\s+acme\+\*@gmail.com/mi) }
  end


  context "when NONE of the [user] and the ppgit variables are stored in the config file"  do
    before do
      contents = [  '[user]'                        ,
                    '[user-before-ppgit]'           ,
                    '[ppgit]'                       ,
      ]
      @output = execute_command("#{PPGIT_CMD} info", contents)
    end

    it('should display the empty [user] section'                 ) { @output.should match(/\[user\]/mi) }

    it('should NOT display the empty [user-before-ppgit] section') { @output.should_not match(/\[user-before-ppgit\]/mi) }
    it('should NOT display the [ppgit] info'                     ) { @output.should_not match(/\[ppgit\]/mi)             }
  end
end
