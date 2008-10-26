lib_dir = File.join(File.dirname(__FILE__), '..', 'lib')
$:.unshift(lib_dir) unless $:.include?(lib_dir)

require 'rbyaml'
include RbYAML

$test_file = "/tmp/rbyaml_test.yml"

def load_yaml(yaml_version = "1.1")
  version_map = {
    "1.0" => "rbyaml_1.0.rb",
    "1.1" => "rbyaml.rb",
  }

  version_map.each do |curr_version, lib_file|
    if yaml_version == curr_version
      load lib_file
    end
  end
end

class TestBean
  attr_accessor :name, :age, :born
  def initialize(name = nil, age = nil, born = nil)
    @name = name
    @age = age
    @born = born
  end

  def == (other)
    @name == other.name && @age == other.age && @born == other.born
  end
end
