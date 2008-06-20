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
end
