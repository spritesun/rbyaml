# Copyright (c) 2007, Evan Phoenix.
# Distributed under BSD License.
# Modified by Long Sun <spritesun@gmail.com>.

require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "RbYAML#load" do
  after :each do
    File.delete $test_file if File.exist? $test_file
  end

  it "should return a document from current io stream when io provided" do
    File.open($test_file, 'w') do |io|
      RbYAML.dump( ['badger', 'elephant', 'tiger'], io )
    end
    File.open($test_file) { |yf| RbYAML.load( yf ) }.should == ['badger', 'elephant', 'tiger']
  end

  it "should return a symbol when accepting a string include symbol" do
    RbYAML.load( "--- :locked" ).should == :locked
  end

  it "should load symbol stream which contains blank successfully" do
    RbYAML.load(":user name: This is the user name.").should == { :'user name' => 'This is the user name.'}
  end

  it "should load String successfully" do
    expected = "str"
    "str".should load_as(expected)
    " str".should load_as(expected)
    %Q{'str'}.should load_as(expected)
    "\"str\"".should load_as(expected)
    "\n str".should load_as(expected)
    "--- str".should load_as(expected)
    "---\nstr".should load_as(expected)
    "--- \nstr".should load_as(expected)
    "--- \n str".should load_as(expected)
    %Q{--- 'str'}.should load_as(expected)
    "!!str str".should load_as(expected)

    "!!str 1.0".should load_as("1.0")
  end

  it "should load !str as application tag in YAML1.0" do
    load "rbyaml_1.0.rb"

    "!str str".should load_as("str")
    "!str 1.0".should load_as("1.0")

    load "rbyaml.rb"
  end

  it "should load Array successfully" do
    expected = ["a", "b", "c"]
    "--- \n- a\n- b\n- c\n".should load_as(expected)
    "--- [a, b, c]".should load_as(expected)
    "[a, b, c]".should load_as(expected)
  end

  it "should load string with empty value as empty string" do
    "---\n!!str".should load_as("")

    load "rbyaml_1.0.rb"
    "---\n!str".should load_as("")
    load "rbyaml.rb"
  end

  it "should load empty yaml file as nil" do
    "".should load_as(nil)
  end
end

class LoadAs #:nodoc:
  def initialize(expected)
    @expected = expected
  end

  def matches?(actual_yaml)
    @actual = RbYAML.load(actual_yaml)
    @actual == (@expected)
  end

  def failure_message
    return "expected #{@expected.inspect}, got #{@actual.inspect} (using .equal?)", @expected, @actual
  end

  def negative_failure_message
    return "expected #{@actual.inspect} not to equal #{@expected.inspect} (using .equal?)", @expected, @actual
  end

  def description
    "equal #{@expected.inspect}"
  end
end

# :call-seq:
#   should load_as(expected)
#
# Passes if actual yaml representation load as expected object.
#
# See http://www.ruby-doc.org/core/classes/Object.html#M001057 for more information about equality in Ruby.
#
# == Examples
#
# #   "--- :lock".should load_as(":lock")
def load_as(expected)
  LoadAs.new(expected)
end
