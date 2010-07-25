require 'ppgit/git_utils'
require 'ppgit/ppgit_utils'


def do_ppgit_clear
  backup_is_same_as_global?('name') ?
    unset_local_git_value('user.name') :
    restore_git_value( :from => 'user-before-ppgit.name', :to => 'user.name')

  backup_is_same_as_global?('email') ?
    unset_local_git_value('user.email') :
    restore_git_value(:from => 'user-before-ppgit.email', :to => 'user.email')

  remove_local_section('user') if empty_local_section?('user')
  remove_local_section('user-before-ppgit')
end


def do_ppgit_emailroot(emailroot)
  set_global_git_value 'ppgit.emailroot', emailroot
end


def do_ppgit_set_pair_as_a_user(user_1, user_2, pair_email)
  backup_git_value :from => 'user.name' , :to => 'user-before-ppgit.name'
  backup_git_value :from => 'user.email', :to => 'user-before-ppgit.email'

  two_users  = [user_1, user_2]
  pair_user  = two_users.sort.join('_')

  pair_email ||= make_email_from_email_root_and_user(pair_user)

  set_local_git_value 'user.name', pair_user
  if pair_email
    set_local_git_value 'user.email', pair_email
  end
end

def make_email_from_email_root_and_user(pair_user)
  emailroot = get_global_git_value('ppgit.emailroot')
  emailroot.blank? ?
      nil :
      emailroot.gsub('*', pair_user)
end


def do_ppgit_show_usage_message
  path = File.expand_path(File.join(File.dirname(__FILE__), 'usage.txt'))
  puts File.open(path).read
end


def do_ppgit_info
  name, email = get_local_git_value('user.name'), get_local_git_value('user.email')
  email_root  = get_local_git_value('ppgit.emailroot')
  s = []
  s << "  -------------------------------------------------------"
  if name.blank? && email.blank?
    s << '  [user] is empty (user.email and user.name are not set)'
  else
    s << '  [user]'
    s << "    name  = #{name }" unless name .blank?
    s << "    email = #{email}" unless email.blank?
    s << '  -------------------------------------------------------'
  end
  unless email_root.blank?
    s << '  [ppgit]'
    s << "    emailroot = #{email_root}" unless email_root.blank?
    s << '  -------------------------------------------------------'
  end
  name, email = get_local_git_value('user-before-ppgit.name'), get_local_git_value('user-before-ppgit.email')
  unless name.blank? && email.blank?
    s << '  [user-before-ppgit]'
    s << "    name  = #{name }" unless name .blank?
    s << "    email = #{email}" unless email.blank?
    s << '  -------------------------------------------------------'
  end
  s << ' '

  puts s.join("\n")
end
