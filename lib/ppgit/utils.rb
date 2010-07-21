def blank?(string_or_nil)
  string_or_nil.nil? || '' == string_or_nil.strip
end


def get_git_value(key)
  value = (`git config #{PPGIT_FILE_PART} --get  #{key}`).chomp
  value
end

def set_git_value(key, value)
  `git config #{PPGIT_FILE_PART} #{key} '#{value}'`
end

def argv_value_of(prefix)
  if (idx = ARGV.index(prefix))
    ARGV.delete_at(idx)             # ex: remove '--files'
    the_value = ARGV.delete_at(idx)
  end
end

def backup_git_value(options)
  source, target = options[:from], options[:to]

  target_already_occupied = !blank?(get_git_value(target))
  nothing_to_backup       =  blank?(get_git_value(source))

  return if target_already_occupied || nothing_to_backup
  set_git_value(target, get_git_value(source))
end

def restore_git_value(options)
  source, target = options[:from], options[:to]

  nothing_to_restore      =  blank?(get_git_value(source))
  return if nothing_to_restore
  set_git_value(target, get_git_value(source))
end

def email_from_email_root_and_user(pair_user)
  emailroot = get_git_value('ppgit.emailroot')
  blank?(emailroot) ? 
      nil :
      emailroot.gsub('*', pair_user)
end


def usage_message
  path = File.expand_path(File.join(File.dirname(__FILE__), 'usage.txt'))
  File.open(path).read
end

def info_message
  name, email = get_git_value('user.name'), get_git_value('user.email')
  email_root  = get_git_value('ppgit.emailroot')
  s = ["\n~/.gitconfig :", "  ..."]
  s << '  -------------------------------------------------------'
  s << '  [user]'
  s << "    name  = #{name }" unless blank?(name )
  s << "    email = #{email}" unless blank?(email)
  s << '  -------------------------------------------------------'
  s << '  [ppgit]'
  s << "    emailroot = #{email_root}" unless blank?(email_root)

  name, email = get_git_value('user-before-ppgit.name'), get_git_value('user-before-ppgit.email')
  s << '  [user-before-ppgit]'
  s << "    name  = #{name }" unless blank?(name )
  s << "    email = #{email}" unless blank?(email)
  s << '  -------------------------------------------------------'
  s << '  ...'

  s.join("\n")
end
