require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "simple: `ppgit --names_separator _SEP_`" do

  before(:all) do
    @cmd = "#{PPGIT_CMD} --names_separator _SEP_"
  end

  context 'when there is no namesseparator yet' do
    before(:all) do
      @before_local    = [ ]
      @before_global   = [ ] # no pair_separator here.
      @actual_local, @actual_global = execute_command_g(@cmd, @before_local, @before_global)
    end

    it("doesn't change .git/config") { @actual_local.should == @before_local.join("\n") }

    it 'stores the names separator in --global (~/.gitconfig)' do
      expected_global= ['[ppgit]'                         ,
                        '  namesseparator = _SEP_'
                        ]
      @actual_global.should == expected_global.join("\n")
    end
  end

  context 'when there is already an namesseparator' do
    before(:all) do
      @before_local    = [ ]
      @before_global   =  ['[ppgit]'                     ,
                          '  namesseparator = OLD_SEP' # <= the old value to replace
                          ]
      @actual_local, @actual_global = execute_command_g(@cmd, @before_local, @before_global)
    end

    it("doesn't change .git/config") { @actual_local.should == @before_local.join("\n") }

    it 'stores the new names separator in --global (~/.gitconfig)' do
      expected_global= ['[ppgit]'                         ,
                        '  namesseparator = _SEP_'
                        ]
      @actual_global.should == expected_global.join("\n")
    end
  end
end

describe "medium: `ppgit john andy --names_separator _SEP_`" do
  before(:all) do
    @cmd = "#{PPGIT_CMD} john andy --names_separator _SEP_"
    before_local    = [  ]
    before_global   = [  ]
    @actual_local, @actual_global = execute_command_g(@cmd, before_local, before_global)
  end

  it 'stores the user in local (.git/config)' do
    expected_local = [  '[user]'                          ,
                        '  name = andy_SEP_john'              ,
                      ].join("\n")
    @actual_local.should == expected_local
  end
  it 'stores the names separator in --global (~/.gitconfig)' do
    expected_global= ['[ppgit]'                         ,
                      '  namesseparator = _SEP_'
                      ].join("\n")
    @actual_global.should == expected_global
  end
end


