$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ppgit'
require 'rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

require 'tempfile'

def temp_from_string(string, file_basename='')
  f = Tempfile.new(file_basename) 
  f.write(string)
  f.close
  f
end


PPGIT_CMD = File.expand_path(File.dirname(__FILE__)) + '/../bin/ppgit'

# Usage :
#  @output = execute_command( ppgit("info"), contents)
def ppgit(string)
  "#{PPGIT_CMD} #{string}"
end


def check_command_result(git_command, before, expected)
  before, expected = before.join("\n"), expected.join("\n")
  config_file_path = temp_from_string(before).path

  `#{git_command} --file #{config_file_path}`

  actual_text = File.open(config_file_path).read.gsub(/\t/, '  ').chomp
  actual_text.should == expected
end

def execute_command_g(git_command, before, before_global)
  before, before_global = before.join("\n"), before_global.join("\n")
  config_file_path = temp_from_string(before       ).path
  global_file_path = temp_from_string(before_global).path

  output = `#{git_command} --file #{config_file_path} --global_file #{global_file_path}`

  actual_text = File.open(config_file_path).read.gsub(/\t/, '  ').chomp
  actual_global_text = File.open(global_file_path).read.gsub(/\t/, '  ').chomp
  [actual_text, actual_global_text, output]
end

def execute_command(git_command, before)
  before = before.join("\n")
  config_file_path = temp_from_string(before).path

  output = `#{git_command} --file #{config_file_path}`
end
