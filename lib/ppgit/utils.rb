def value_of(prefix)
  if (idx = ARGV.index(prefix))
    ARGV.delete_at(idx)             # ex: remove '--files'
    the_value = ARGV.delete_at(idx)
  end
end

def copy_git_value(options)
  old_value = (`git config #{options[:file_part]} --get  #{options[:from]}`).chomp
  if '' != old_value
    `git config #{options[:file_part]} #{options[:to]} '#{old_value}'`
  end
end

def store_git_value(value, options)
  `git config #{options[:file_part]} #{options[:to]} #{value}`
end
