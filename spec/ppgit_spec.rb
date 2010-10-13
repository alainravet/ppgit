require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

EMPTY_LOCAL_GIT_CONFIG  = []

context "with empty git config files"  do
  before(:all) do
    @before_local    = [ ]
    @before_global   = [ ]
  end

  describe "`ppgit john andy`" do
    before(:all) do
      cmd = ppgit('john andy')
      @actual_local, @actual_global = execute_command_g( cmd, @before_local, @before_global)
    end
    it("combines the 2 names alphabetically and stores this user.name in  .git/config" ) do
      expected_local = ['[user]'              ,
                        '  name = andy+john'  ]
      @actual_local.should == expected_local.join("\n")
    end
    it("adds the default names separator to the global config (~/.gitconfig)") do
      augmented_global = @before_global + ['[ppgit]', "  namesseparator = #{Ppgit::DEFAULT_PAIR_NAME_SEPARATOR}"]
      @actual_global.should == (augmented_global).join("\n")
    end
  end


  describe "`ppgit john andy andy_john@test.com`" do
    before(:all) do
      cmd = ppgit('john andy andy_john@test.com')
      @actual_local, @actual_global = execute_command_g( cmd, @before_local, @before_global)
    end
    it "also stores the 3rd parameter as user.email in .git/config" do
      expected_local = ['[user]'                        ,
                        '  name = andy+john'            ,
                        '  email = andy_john@test.com'  ]

      @actual_local.should == expected_local.join("\n")
    end
    it("adds the default names separator to the global config (~/.gitconfig)") do
      augmented_global = @before_global + ['[ppgit]', "  namesseparator = #{Ppgit::DEFAULT_PAIR_NAME_SEPARATOR}"]
      @actual_global.should == (augmented_global).join("\n")
    end
  end
end


context 'when there is only a ppgit.emailroot' do
  before(:all) do
    @before_local    = [ ]
    @before_global   = ['[ppgit]'                         ,
                        '  emailroot = pp+*@gmail.com'    ]
  end
  describe "`ppgit john andy`" do
    before(:all) do
      cmd = ppgit('john andy')
      @actual_local, @actual_global = execute_command_g( cmd, @before_local, @before_global)
    end
    it( 'combines the users names and the emailroot to create and store user.email' ) do
      expected_local = ['[user]'              ,
                        '  name = andy+john'  ,
                        '  email = pp+andy_john@gmail.com'  ]
      @actual_local.should == expected_local.join("\n")
    end
    it("adds the default names separtor to the global config (~/.gitconfig)") do
      augmented_global = @before_global + ["  namesseparator = #{Ppgit::DEFAULT_PAIR_NAME_SEPARATOR}"]
      @actual_global.should == (augmented_global).join("\n")
    end
  end
end


context 'when there is only a user.name' do
  before(:all) do
    @before_local    = ['[user]' ,
                        '  name = Alain Ravet']
    @before_global   = []
  end


  it '`ppgit john andy` stores the existing user.name and sets the pair user as the new user.name' do
    cmd = ppgit('john andy' )
    @actual_local, @actual_global = execute_command_g( cmd, @before_local, @before_global)
    expected_local = ['[user]'                ,
                      '  name = andy+john'    ,
                      '[user-before-ppgit]'   ,
                      '  name = Alain Ravet'  ]
    @actual_local.should == expected_local.join("\n")
  end

  it '`ppgit john andy andy_john@test.com` uses the 3rd parameter as new user.email' do
    cmd = ppgit('john andy andy_john@test.com' )
    @actual_local, @actual_global = execute_command_g( cmd, @before_local, @before_global)
    expected_local = ['[user]'                ,
                      '  name = andy+john'    ,
                      '  email = andy_john@test.com'    ,
                      '[user-before-ppgit]'   ,
                      '  name = Alain Ravet'  ]
    @actual_local.should == expected_local.join("\n")
  end
end


context 'when there is a user.name and a user.email' do
  before(:all) do
    @before_local    = ['[user]' ,
                        '  name = Alain Ravet'            ,
                        '  email = alainravet@gmail.com'  ]
    @before_global   = []
  end

  it '`ppgit john andy andy_john@test.com` stores the 2 existing values in [user-before-ppgit]' do
    cmd = ppgit('john andy andy_john@test.com' )
    @actual_local, @actual_global = execute_command_g( cmd, @before_local, @before_global)
    expected_local = ['[user]'                ,
                      '  name = andy+john'    ,
                      '  email = andy_john@test.com',
                      '[user-before-ppgit]'   ,
                      '  name = Alain Ravet'  ,
                      '  email = alainravet@gmail.com'  ]
    @actual_local.should == expected_local.join("\n")
  end
end


context 'when there is a user.name + email AND stored values in [user-before-ppgit]' do
  before(:all) do
    @before_local    = ['[user]' ,
                        '  name = andy+john'            ,
                        '  email = andy_john@test.com'  ,
                        '[user-before-ppgit]'             ,
                        '  name = Alain Ravet'            ,
                        '  email = alainravet@gmail.com'  ]
    @before_global   = []
    cmd = ppgit('artie zane artie_zane@test.com' )
    @actual_local, @actual_global, @output = execute_command_g( cmd, @before_local, @before_global)
  end

  it '`ppgit artie zane artie_zane@test.com`  does not overwrite the values stored in user-before-ppgit' do
    expected_local = ['[user]'                ,
                      '  name = artie+zane'    ,
                      '  email = artie_zane@test.com',
                      '[user-before-ppgit]'   ,
                      '  name = Alain Ravet'  ,
                      '  email = alainravet@gmail.com'  ]
    @actual_local.should == expected_local.join("\n")
  end
  it "displays the info after the fact" do
    @output.should match(/\[user\].+artie_zane@test.com/mi)
  end

end

context 'when there is only global user.name and user.email' do
  before(:all) do
    @before_local   = []
    @before_global  = ['[user]' ,
                        '  name = Alain Ravet'            ,
                        '  email = alainravet@gmail.com'  ]
  end

  it '`ppgit john andy andy_john@test.com` stores the 2 existing values in [user-before-ppgit]' do
    cmd = ppgit('john andy andy_john@test.com' )
    @actual_local, @actual_global = execute_command_g( cmd, @before_local, @before_global)
    expected_local = [
                      '[user-before-ppgit]'   ,
                      '  name = Alain Ravet'  ,
                      '  email = alainravet@gmail.com',
                      '[user]'                ,
                      '  name = andy+john'    ,
                      '  email = andy_john@test.com',
]
    @actual_local.should == expected_local.join("\n")
  end
end
