def get_local_git_value( key) get_value(key, LOCAL_CONFIG_FILE ) end
def get_global_git_value(key) get_value(key, GLOBAL_CONFIG_FILE) end

def set_local_git_value( key, value) set_value(key, value, LOCAL_CONFIG_FILE ) end
def set_global_git_value(key, value) set_value(key, value, GLOBAL_CONFIG_FILE) end

def unset_local_git_value( key) `git config #{LOCAL_CONFIG_FILE} --unset #{key}` end

def remove_local_section(section)
`git config #{LOCAL_CONFIG_FILE} --remove-section #{section} 2> /dev/null`
end

def get_value(key, where)
  (`git config #{where} #{key}`).chomp
end

def set_value(key, value, where)
  `git config #{where} #{key} '#{value}'`
end


def empty_local_section?(section)
  res = `git config #{LOCAL_CONFIG_FILE} --get-regexp  user`
  nof_values_in_section = res.
                    split("\n").                                # 1 line per match
                    select{|s| s.start_with?("#{section}.")}.   # reject [foot] when testing [foo]
                    size
  0 == nof_values_in_section
end
