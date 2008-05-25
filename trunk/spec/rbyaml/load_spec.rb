# Copyright (c) 2007, Evan Phoenix.
# Distributed under BSD License.
# Modified by Long Sun <spritesun@gmail.com>.

require File.join(File.dirname(__FILE__), "rbyaml_helper")

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
    "--- :locked".should load_as(:locked)
  end

  it "should load symbol stream which contains blank successfully" do
    expected = { :'user name' => 'This is the user name.'}
    %Q{:user name: This is the user name.}.should load_as(expected)
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
    "---\n!!str".should load_as(String.new)
    "---\n- !!str\n- :symbol".should load_as([String.new, :symbol])

    load "rbyaml_1.0.rb"
    "---\n!str".should load_as(String.new)
    load "rbyaml.rb"
  end

  it "should load empty yaml file as nil" do
    "".should load_as(nil)
  end

  it "should load various object with empty value as emtpy object" do
    pending
    "!!object".should load_as(Object.new)
    "!!null".should load_as(NilClass.new)
  end

end
