require 'open-uri'

def latest_github_version(user, project, branch='master', file='VERSION')
  @@latest_github_version ||= read_file_from_github(user, project, branch, file)
end

def latest_github_changelog(user, project, branch='master', file='CHANGELOG', old_version=nil)
  all_lines = read_file_lines_from_github(user, project, branch, file)
  (all_lines || []).map{|line| line.chomp}.take_while{|line| line != old_version}
end


def read_file_from_github(user, project, branch, file)
  file_path = "https://github.com/#{user}/#{project}/raw/#{branch}/#{file}"
  begin
    contents = open(file_path).read.chomp # ex: '1.2.3'
  rescue => e #SocketError, OpenURI::HTTPError
    puts file_path
    puts e.inspect
    nil    # unable to read the file
  end
end

def read_file_lines_from_github(user, project, branch, file)
  file_path = "https://github.com/#{user}/#{project}/raw/#{branch}/#{file}"
  begin
    open(file_path).readlines
  rescue SocketError, OpenURI::HTTPError
    nil    # unable to read the file
  end
end

