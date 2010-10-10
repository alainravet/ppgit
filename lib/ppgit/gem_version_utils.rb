require 'open-uri'

def latest_github_version(user, project)
  version_path = "http://github.com/#{user}/#{project}/raw/master/VERSION"
  begin
    version = open(version_path).read.chomp # ex: '1.2.3'
  rescue SocketError
    # unable to fetch the version
  end
end

def this_version
  version_file = File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'VERSION')
  File.open(version_file).read.chomp
end

def new_version_available?(project, user)
  this_version != latest_github_version(user, project)
end

def print_message_if_new_version_available(user, project)
  if new_version_available?(project, user)
    s = ["\033[1;33m"]  # yellow
    s << '------------------------------------------------------'
    s << "  There is a new version of #{project} (#{latest_github_version(user, project)})."
    s << "  You are using version  #{this_version}"
    s << '  To update :'
    s << "      gem update #{project}"
    s << '------------------------------------------------------'
    s << "\033[0m"      # no color
    msg = s.join("\n")
    puts msg
  end
end
