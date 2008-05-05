lib_dir = File.join(File.dirname(__FILE__), '..', 'lib')
$:.unshift(lib_dir) unless $:.include?(lib_dir)

require 'rbyaml'

$test_file = "/tmp/rbyaml_test.yml"
