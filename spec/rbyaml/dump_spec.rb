# Copyright (c) 2007, Evan Phoenix
# Distributed under BSD License
# Modified by Long Sun

require File.join(File.dirname(__FILE__), "rbyaml_helper")

describe "RbYAML.dump" do
  after :each do
    File.delete $test_file if File.exist? $test_file
  end

  it "should converts an object to RbYAML and write result to io when io provided" do
    File.open($test_file, 'w' ) do |io|
      RbYAML.dump( ['badger', 'elephant', 'tiger'], io )
    end
    RbYAML.load_file($test_file).should == ['badger', 'elephant', 'tiger']
  end

  it "should returns a string containing dumped RbYAML when no io provided" do
    :locked.should dump_as("--- :locked\n")
  end

  it "should dump basic string successfully" do
    "str".should dump_as("--- str\n")
  end

  it "could dump basic hash" do
    { "a" => "b" }.should dump_as("--- \na: b\n")
  end

  it "could dump basic list" do
    ["a", "b", "c"].should dump_as("--- \n- a\n- b\n- c\n")
  end

  it "should dump tag information during option is explicit type " do
    RbYAML.dump(1, nil, { :ExplicitTypes => true} ).should == "--- !!int 1\n"
  end

  it "should dump string tag information during the string is integer" do
    "3.14".should dump_as("--- !!str 3.14\n")
    "1.0".should dump_as("--- !!str 1.0\n")
  end

  it "could dump object" do
    TestBean.new("sprite", 19, Date.civil(1988, 6, 27)).should dump_as("--- !ruby/object:TestBean\nage: 19\nborn: 1988-06-27\nname: sprite\n")
  end

  it "should dump blank line started string to block chomping mode" do
    "\nabc".should dump_as("--- |-\n  \n  abc\n")
  end

  it "could dump by options" do
    RbYAML.dump(:some, nil, :UseVersion => true, :UseHeader => true).should load_as(:some)
  end

  it "could dump recursive array" do
    recursive_array = []; recursive_array[0] = recursive_array

    recursive_array.should dump_as("--- &id001\n- *id001\n")
  end

  it "could dump recursive map" do
    recursive_map = { }; recursive_map[recursive_map] = recursive_map

    recursive_map.should dump_as("--- &id001\n*id001: *id001\n")
  end

end
