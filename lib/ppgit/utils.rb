def blank?(string_or_nil)
  string_or_nil.nil? || '' == string_or_nil.strip
end


def get_git_value(key, options)
  value = (`git config #{options[:file_part]} --get  #{key}`).chomp
  value
end

def set_git_value(key, value, options)
  `git config #{options[:file_part]} #{key} '#{value}'`
end

def argv_value_of(prefix)
  if (idx = ARGV.index(prefix))
    ARGV.delete_at(idx)             # ex: remove '--files'
    the_value = ARGV.delete_at(idx)
  end
end

def backup_git_value(options)
  source, target = options[:from], options[:to]

  target_already_occupied = !blank?(get_git_value(target,  :file_part => options[:file_part]))
  nothing_to_backup       =  blank?(get_git_value(source,  :file_part => options[:file_part]))

  return if target_already_occupied || nothing_to_backup
  set_git_value(target, get_git_value(source,  :file_part => options[:file_part]), :file_part => options[:file_part])
end

def restore_git_value(options)
  source, target = options[:from], options[:to]

  nothing_to_restore      =  blank?(get_git_value(source,  :file_part => options[:file_part]))
  return if nothing_to_restore
  set_git_value(target, get_git_value(source,  :file_part => options[:file_part]), :file_part => options[:file_part])
end
