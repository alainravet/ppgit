require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "`ppgit --email_root acme+*@gmail.com`" do
  before(:all) do
    @cmd = "#{PPGIT_CMD} --email_root acme+*@gmail.com"
  end

  example 'when there is no emailroot yet' do
    before   = [  '[a]'                 ]

    expected = [  '[a]'                             ,
                  '[ppgit]'                         ,
                  '  emailroot = acme+*@gmail.com'  ]
    check_command_result(@cmd, before, expected)
  end


  example 'when there is an emailroot' do
    before   = [  '[ppgit]'                         ,
                  '  emailroot = old+*@gmail.com'  ]
    expected = [  '[ppgit]'                         ,
                  '  emailroot = acme+*@gmail.com'  ]

    check_command_result(@cmd, before, expected)
  end
end
