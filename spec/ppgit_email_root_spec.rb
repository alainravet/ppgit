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

describe "`ppgit john andy --email_root acme+*@gmail.com`" do
  before(:all) do
    @cmd = "#{PPGIT_CMD} john andy --email_root acme+*@gmail.com"
  end

  it 'generates an email for the pair from the root AND stores the email_root' do
    before   = [  '[z]'                 ]

    expected = [  '[z]'                             ,
                  '[ppgit]'                         ,
                  '  emailroot = acme+*@gmail.com'  ,
                  '[user]'                          ,
                  '  name = andy_john'              ,
                  '  email = acme+andy_john@gmail.com' ,
                ]

    check_command_result(@cmd, before, expected)
  end
end

describe "`ppgit john andy andy_john@test.com --email_root acme+*@gmail.com`" do
  before(:all) do
    @cmd = "#{PPGIT_CMD} john andy andy_john@test.com --email_root acme+*@gmail.com"
  end

  it 'stores the email_root BUT uses the explicit pair email address' do
    before   = [  '[z]'                 ]

    expected = [  '[z]'                             ,
                  '[ppgit]'                         ,
                  '  emailroot = acme+*@gmail.com'  ,
                  '[user]'                          ,
                  '  name = andy_john'              ,
                  '  email = andy_john@test.com' ,
                ]

    check_command_result(@cmd, before, expected)
  end
end
