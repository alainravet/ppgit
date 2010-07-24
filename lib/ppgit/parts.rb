require 'ppgit/utils'


def do_ppgit_clear
  restore_git_value :from => 'user-before-ppgit.name', :to => 'user.name'
  restore_git_value :from => 'user-before-ppgit.email', :to => 'user.email'
  `git config #{PPGIT_FILE_PART} --remove-section user-before-ppgit 2> /dev/null`
end


def do_ppgit_emailroot(emailroot)
  set_git_value 'ppgit.emailroot', emailroot
end


def do_ppgit_set_pair_as_a_user(user_1, user_2, pair_email)
  backup_git_value :from => 'user.name' , :to => 'user-before-ppgit.name'
  backup_git_value :from => 'user.email', :to => 'user-before-ppgit.email'

  two_users  = [user_1, user_2]
  pair_user  = two_users.sort.join('_')

  pair_email ||= email_from_email_root_and_user(pair_user)

  set_git_value 'user.name', pair_user
  if pair_email
    set_git_value 'user.email', pair_email
  end
end


def do_ppgit_show_usage_message
  path = File.expand_path(File.join(File.dirname(__FILE__), 'usage.txt'))
  puts File.open(path).read
end


def do_ppgit_info(source=nil)
  name, email = get_git_value('user.name', source), get_git_value('user.email', source)
  email_root  = get_git_value('ppgit.emailroot', source)
  s = ["\n~/.gitconfig :", "  ..."]
  s = []
  s << "  ------------------------------------------------------- #{source}"
  if blank?(name) && blank?(email)
    s << '  [user] is empty (user.email and user.name are not set)'
  else
    s << '  [user]'
    s << "    name  = #{name }" unless blank?(name )
    s << "    email = #{email}" unless blank?(email)
    s << '  -------------------------------------------------------'
  end
  unless blank?(email_root)
    s << '  [ppgit]'
    s << "    emailroot = #{email_root}" unless blank?(email_root)
    s << '  -------------------------------------------------------'
  end
  name, email = get_git_value('user-before-ppgit.name', source), get_git_value('user-before-ppgit.email', source)
  unless blank?(name) && blank?(email)
    s << '  [user-before-ppgit]'
    s << "    name  = #{name }" unless blank?(name )
    s << "    email = #{email}" unless blank?(email)
    s << '  -------------------------------------------------------'
  end
  s << ' '

  puts s.join("\n")
end
