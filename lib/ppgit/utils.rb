
# ------------------------------------------------------------------------

def argv_value_of(prefix)
  if (idx = ARGV.index(prefix))
    ARGV.delete_at(idx)             # ex: remove '--files'
    the_value = ARGV.delete_at(idx)
  end
end

def blank?(string_or_nil)
  string_or_nil.nil? || ('' == string_or_nil.strip)
end

# separator = --file, or --global_file
def config_file_part(separator)
  (config_file = argv_value_of(separator)) ?
    "--file #{config_file}" :
    nil
end

# ------------------------------------------------------------------------
def backup_is_same_as_global?(key)
  return false if blank?(get_local_git_value('user-before-ppgit.'+key))
  equality = get_local_git_value('user-before-ppgit.'+key) == get_global_git_value('user.'+key)
end

def get_local_git_value( key) get_value(key, LOCAL_CONFIG_FILE ) end
def get_global_git_value(key) get_value(key, GLOBAL_CONFIG_FILE) end

def set_local_git_value( key, value) set_value(key, value, LOCAL_CONFIG_FILE ) end
def set_global_git_value(key, value) set_value(key, value, GLOBAL_CONFIG_FILE) end

def unset_local_git_value( key) `git config #{LOCAL_CONFIG_FILE} --unset #{key}` end

def remove_local_section(section)
`git config #{LOCAL_CONFIG_FILE} --remove-section #{section} 2> /dev/null`
end

def get_value(key, where)
  (`git config #{where} --get  #{key}`).chomp
end
def set_value(key, value, where)
  `git config #{where} #{key} '#{value}'`
end

# ------------------------------------------------------------------------

def make_email_from_email_root_and_user(pair_user)
  emailroot = get_global_git_value('ppgit.emailroot')
  blank?(emailroot) ?
      nil :
      emailroot.gsub('*', pair_user)
end

# ------------------------------------------------------------------------

def backup_git_value(options)
  source, target = options[:from], options[:to]

  target_already_occupied = !blank?(get_local_git_value(target))
  nothing_to_backup       =  blank?(get_local_git_value(source))

  return if target_already_occupied || nothing_to_backup
  set_local_git_value(target, get_local_git_value(source))
end

def restore_git_value(options)
  source, target = options[:from], options[:to]

  nothing_to_restore      =  blank?(get_local_git_value(source))
  return if nothing_to_restore
  set_local_git_value(target, get_local_git_value(source))
end

# ------------------------------------------------------------------------
