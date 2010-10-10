require 'ppgit/github_utils'

def this_version
  version_file = File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'VERSION')
  File.open(version_file).read.chomp
end

def new_version_available?(user, project)
  latest_version = latest_github_version(user, project)
  # latest_version.nil? if the info cannot be retrieved from github.com
  latest_version && this_version != latest_version
end

def print_message_if_new_version_available
  user    = Ppgit::Github::USER
  project = Ppgit::Github::PROJECT
  changelog = latest_github_changelog(user, project, 'master', 'CHANGELOG', this_version)

  if new_version_available?(user, project)
    s = ["\033[1;33m"]  # yellow
    s << '------------------------------------------------------'
    s << "  There is a new version of #{project} (#{latest_github_version(user, project)})."
    s << "  You are using version  #{this_version}"
    s << '  To update :'
    s << "      #{red("gem update " + project)}"
    s << '------------------------------------------------------'
    s << "\033[0m"      # no color
    s << '------------------------------------------------------'
    unless changelog.empty?
      s << " CHANGELOG :"
      s << '------------------------------------------------------'
      s << changelog.map{|l| l.chomp}
      s << this_version
      s << '  ...'
      s << '------------------------------------------------------'
    end
    msg = s.join("\n")
    puts msg

    puts "Note: you can prevent the version check with :"
    puts "   PPGIT_NO_VERSION_CHECK=true ppgit <command>"
    puts ''
  end
end
