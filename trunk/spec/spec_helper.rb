unless defined?(BASE_DIR)
  BASE_DIR = File.dirname(__FILE__)
  LIB_DIR = File.join(File.dirname(__FILE__), "..", "lib")
  $:.unshift(LIB_DIR) unless $:.include?(LIB_DIR)

  require 'rbyaml'
  require File.join(BASE_DIR, 'rspec_extension')

  include RbYAML
  include RSpecExtension

  $test_file = "/tmp/rbyaml_test.yml"
end
