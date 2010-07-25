require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "simple: `ppgit --email_root acme+*@gmail.com`" do
  before(:all) do
    @cmd = "#{PPGIT_CMD} --email_root acme+*@gmail.com"
  end

  context 'when there is no emailroot yet' do
    before(:all) do
      @before_local    = [ ]
      @before_global   = [ ] # no emailroot here
      @actual_local, @actual_global = execute_command_g(@cmd, @before_local, @before_global)
    end

    it("doesn't change .git/config") { @actual_local.should == @before_local.join("\n") }

    it 'stores the emailroot in --global (~/.gitconfig)' do
      expected_global= ['[ppgit]'                         ,
                        '  emailroot = acme+*@gmail.com'
                        ]
      @actual_global.should == expected_global.join("\n")
    end
  end


  context 'when there is already an emailroot' do
    before(:all) do
      @before_local    = [ ]
      @before_global   =  ['[ppgit]'                     ,
                          '  emailroot = old+*@gmail.com' # <= the old value to replace
                          ]
      @actual_local, @actual_global = execute_command_g(@cmd, @before_local, @before_global)
    end

    it("doesn't change .git/config") { @actual_local.should == @before_local.join("\n") }

    it 'stores the new emailroot in --global (~/.gitconfig)' do
      expected_global= ['[ppgit]'                         ,
                        '  emailroot = acme+*@gmail.com'
                        ]
      @actual_global.should == expected_global.join("\n")
    end
  end
end

describe "medium: `ppgit john andy --email_root acme+*@gmail.com`" do
  before(:all) do
    @cmd = "#{PPGIT_CMD} john andy --email_root acme+*@gmail.com"
    before_local    = [  ]
    before_global   = [  ]
    @actual_local, @actual_global = execute_command_g(@cmd, before_local, before_global)
  end

  it 'stores the user in local (.git/config)' do
    expected_local = [  '[user]'                          ,
                        '  name = andy_john'              ,
                        '  email = acme+andy_john@gmail.com'
                      ].join("\n")
    @actual_local.should == expected_local
  end
  it 'stores the emailroot in --global (~/.gitconfig)' do
    expected_global= ['[ppgit]'                         ,
                      '  emailroot = acme+*@gmail.com'
                      ].join("\n")
    @actual_global.should == expected_global
  end
end


describe "complex: `ppgit john andy andy_john@test.com --email_root acme+*@gmail.com`" do
  before(:all) do
    @cmd = "#{PPGIT_CMD} john andy andy_john@test.com --email_root acme+*@gmail.com"
    before_local    = [  ]
    before_global   = [  ]
    @actual_local, @actual_global = execute_command_g(@cmd, before_local, before_global)
  end

  it 'uses the explicit email address (3rd parameter)' do
    expected_local = [  '[user]'                          ,
                        '  name = andy_john'              ,
                        '  email = andy_john@test.com'
                      ].join("\n")
    @actual_local.should == expected_local
  end

  it 'stores the emailroot in --global (~/.gitconfig)' do
    expected_global= ['[ppgit]'                         ,
                      '  emailroot = acme+*@gmail.com'
                      ].join("\n")
    @actual_global.should == expected_global
  end
end
