require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "`ppgit clear`" do
  before(:all) do
    @cmd = "#{PPGIT_CMD} clear"
  end

  example 'when there is no user name nor email nor ppgit.email.root in the config' do
    before   = [    '[a]'                 ]
    expected = before
    check_command_result(@cmd, before, expected)
  end


  example 'when there is a user.name and a user.email but no backed-up values' do
    before   = [  '[user]'                          ,
                  '  name = Alain Ravet'            ,
                  '  email = alainravet@gmail.com'  ]
    expected = before

    check_command_result(@cmd, before, expected)
  end


  example 'when there is a user.name + email AND stored values in user-before-ppgit' do
    before = [    '[user]'                        ,
                  '  name = andy_john'            ,  # value to replace
                  '  email = andy_john@test.com'  ,  #  ..

                  '[user-before-ppgit]'             , # section to erase
                  '  name = Alain Ravet'            , # value to restore
                  '  email = alainravet@gmail.com'  ] #   ..

    expected = [  '[user]'                        ,
                  '  name = Alain Ravet'          , # restored value
                  '  email = alainravet@gmail.com'] #  ..

    check_command_result(@cmd, before, expected)
  end

  example 'when there is an emailroot : the emailroot is not cleared' do
    before   = [  '[ppgit]'                         ,
                  '  emailroot = old+*@gmail.com'  ]
    expected = before

    check_command_result(@cmd, before, expected)
  end

end
