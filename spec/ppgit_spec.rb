require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "`ppgit john andy`" do

  context 'when there is no user name nor email nor ppgit.email.root in the config' do
    before = [    '[a]'                 ]

    it "combines the names alphabetically and stores them a the new user.name" do
      expected = [  '[a]'                 ,
                    '[user]'              ,
                    '  name = andy_john'  ]

      cmd = "#{PPGIT_CMD} john andy"
      check_command_result(cmd, before, expected)
    end

    it "uses the 3rd parameter as new user.email" do
      expected = [  '[a]'                           ,
                    '[user]'                        ,
                    '  name = andy_john'            ,
                    '  email = andy_john@test.com'  ]

      cmd = "#{PPGIT_CMD} john andy andy_john@test.com"
      check_command_result(cmd, before, expected)
    end
  end


  context 'when there is a user.name' do
    before = [    '[user]'                ,
                  '  name = Alain Ravet'  ]

    it "stores the existing user.name and sets the pair user as the new user.name" do
      expected = [  '[user]'                ,
                    '  name = andy_john'    ,
                    '[user-before-ppgit]'   ,
                    '  name = Alain Ravet'  ]

      cmd = "#{PPGIT_CMD} john andy"
      check_command_result(cmd, before, expected)
    end

    it "uses the 3rd parameter as new user.email" do
      expected = [  '[user]'                        ,
                    '  name = andy_john'            ,
                    '  email = andy_john@test.com'  ,
                    '[user-before-ppgit]'           ,
                    '  name = Alain Ravet'          ]

      cmd = "#{PPGIT_CMD} john andy andy_john@test.com"
      check_command_result(cmd, before, expected)
    end
  end


  context 'when there is a user.name and a user.email' do
    before = [    '[user]'                          ,
                  '  name = Alain Ravet'            ,
                  '  email = alainravet@gmail.com'  ]


    it "stores the 2 existing values and sets the pair email and name as the new values" do
      expected = [  '[user]'                        ,
                    '  name = andy_john'            ,
                    '  email = andy_john@test.com'  ,
                    '[user-before-ppgit]'           ,
                    '  name = Alain Ravet'          ,
                    '  email = alainravet@gmail.com']

      cmd = "#{PPGIT_CMD} john andy andy_john@test.com"
      check_command_result(cmd, before, expected)
    end
  end


  context 'when there is a user.name + email AND stored values in user-before-ppgit' do
    before = [    '[user]'                          ,
                  '  name = andy_john'            ,
                  '  email = andy_john@test.com'  ,

                  '[user-before-ppgit]'             ,
                  '  name = Alain Ravet'            ,
                  '  email = alainravet@gmail.com'  ]


    it "does not overwrite the values stored in user-before-ppgit" do
      expected = [  '[user]'                        ,
                    '  name = artie_zane'           , # new values
                    '  email = artie_zane@test.com' , #  ..

                    '[user-before-ppgit]'           ,
                    '  name = Alain Ravet'          , # not touched
                    '  email = alainravet@gmail.com'] #  ..

      cmd = "#{PPGIT_CMD} artie zane artie_zane@test.com"
      check_command_result(cmd, before, expected)
    end
  end
end
