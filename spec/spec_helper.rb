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

def expected_contents(file_name)
  f = File.expand_path(File.dirname(__FILE__) + "/fixtures/#{file_name}")  
  File.open(f).read
end

PPGIT_CMD = File.expand_path(File.dirname(__FILE__)) + '/../bin/ppgit'

def assert_same_contents(actual_file, expected_fixture_name)
  File.open(actual_file.path).read.gsub(/\t/, '  ').chomp.should == expected_contents(expected_fixture_name)
end
  