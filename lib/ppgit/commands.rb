require 'ppgit/git_utils'
require 'ppgit/ppgit_utils'
require 'ppgit/gem_version_utils'

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


def do_ppgit_set_pair_as_a_user(user_1, user_2, pair_email, names_separator)
  backup_git_value :from => 'user.name' , :to => 'user-before-ppgit.name'
  backup_git_value :from => 'user.email', :to => 'user-before-ppgit.email'

  pair_email ||= make_email_from_email_root_and_user(user_1, user_2)

  set_local_git_value 'user.name', assemble_pair_name(user_1, user_2, names_separator)
  if pair_email
    set_local_git_value 'user.email', pair_email
  end
end

def make_email_from_email_root_and_user(user_1, user_2)
  emailroot = get_global_git_value('ppgit.emailroot')
  emailroot.blank? ?
      nil :
      emailroot.gsub('*', assemble_email_user(user_1, user_2))
end


def do_ppgit_show_usage_message
  path = File.expand_path(File.join(File.dirname(__FILE__), 'usage.txt'))
  puts File.open(path).read
end

def do_ppgit_show_quick_usage_message
  path = File.expand_path(File.join(File.dirname(__FILE__), 'quick_usage.txt'))
  puts File.open(path).read
end


def do_ppgit_info
  ppgit_info(LOCAL_CONFIG_FILE )
  ppgit_info(GLOBAL_CONFIG_FILE)
end

def ppgit_info(file)
  name, email     = get_value('user.name', file), get_value('user.email', file)
  names_separator = get_value('ppgit.namesseparator', file)
  email_root      = get_value('ppgit.emailroot'     , file)
  s = []
  s << "-------------------------------------------------------"
  s << "file = " + ((file == '--global') ? '~/.gitconfig' : file.gsub('--file ',''))
  s << "-------------------------------------------------------"
  unless name.blank? && email.blank?
#    s << '  [user] is empty (user.email and user.name are not set)'
#  else
    s << '  [user]'
    s << red("    name  = #{name }") unless name.blank?
    s << red("    email = #{email}") unless email.blank?
    s << '  -------------------------------------------------------'
  end

  unless email_root.blank? && names_separator.blank?
    s << '  [ppgit]'
    unless email_root.blank?
      sample_email = make_email_from_email_root_and_user('ann', 'bob')
      s << "    emailroot = #{yellow(email_root)}   # -> `ppgit ann bob`  -> user.email = #{yellow(sample_email)}"
    end
    unless names_separator.blank?
      sample_name = assemble_pair_name('ann', 'bob', names_separator)
      s << "    namesseparator = #{yellow(names_separator)}    # -> `ppgit ann bob`  -> user.name = #{yellow(sample_name)}"
    end
    s << '  -------------------------------------------------------'
  end

  name, email = get_value('user-before-ppgit.name', file), get_value('user-before-ppgit.email', file)
  unless name.blank? && email.blank?
    s << '  [user-before-ppgit]  # values restored by `ppgit clear`'
    s << "    name  = #{name }" unless name.blank?
    s << "    email = #{email}" unless email.blank?
    s << '  -------------------------------------------------------'
  end
  s << ' '
  puts green s.join("\n")
end

