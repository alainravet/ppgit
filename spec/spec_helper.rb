$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ppgit'
require 'spec'
require 'spec/autorun'


Spec::Runner.configure do |config|

end


# ------------------------------------------------------------------------------
# setup helpers
# ------------------------------------------------------------------------------

require 'tempfile'
require 'ftools'

def temp_from_model(model, file_basename=nil)
  newfile = Tempfile.new(file_basename)
  source_path = File.expand_path(File.dirname(__FILE__) + "/fixtures/#{model}")
  File.copy(source_path, newfile.path)
  newfile
end

def temp_from_string(string, file_basename=nil)
  f = Tempfile.new(file_basename) 
  f.write(string)
  f.close
  f
end

def expected_contents(file_name)
  f = File.expand_path(File.dirname(__FILE__) + "/fixtures/#{file_name}")
  File.open(f).read
end

PPGIT_CMD = File.expand_path(File.dirname(__FILE__)) + '/../bin/ppgit'

def check_command_result(git_command, before, expected)
  before, expected = before.join("\n"), expected.join("\n")
  config_file_path = temp_from_string(before).path

  `#{git_command} --file #{config_file_path}`

  actual_text = File.open(config_file_path).read.gsub(/\t/, '  ').chomp
  actual_text.should == expected
end

def execute_command(git_command, before)
  before = before.join("\n")
  config_file_path = temp_from_string(before).path

  output = `#{git_command} --file #{config_file_path}`
end
