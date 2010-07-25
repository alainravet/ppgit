require 'ppgit/utils'
require 'ppgit/git_utils'

# separator = --file, or --global_file
# Returns :
#   nil
# or
#   --file /path/to/a_config_file
#
def config_file_part(separator)
  (config_file = argv_value_of(separator)) ?
    "--file #{config_file}" :
    nil
end

def backup_is_same_as_global?(key)
  backup_value  = get_local_git_value( 'user-before-ppgit.' + key)
  local_value   = get_global_git_value('user.' + key)
  return false if backup_value.blank?
  is_same_value = backup_value == local_value
end

# ------------------------------------------------------------------------

def backup_git_value(options)
  source, target = options[:from], options[:to]

  target_already_occupied = !get_local_git_value(target).blank?
  nothing_to_backup       =  get_local_git_value(source).blank?

  return if target_already_occupied || nothing_to_backup
  set_local_git_value(target, get_local_git_value(source))
end

def restore_git_value(options)
  source, target = options[:from], options[:to]

  nothing_to_restore      =  get_local_git_value(source).blank?
  return if nothing_to_restore
  set_local_git_value(target, get_local_git_value(source))
end

# ------------------------------------------------------------------------
