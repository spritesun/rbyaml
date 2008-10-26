# Copyright (c) 2007, Evan Phoenix
# Distributed under BSD License
# Modified by Long Sun

require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "Object#to_yaml" do
  it "returns the RbYAML representation of a Symbol" do
    :symbol.to_yaml.should ==  "--- :symbol\n"
  end

  it "should parse string to YAML representation" do
    "this is a string".to_yaml.should == "--- this is a string\n"
  end

  it "should has to_yaml method" do
    Hash.instance_methods(false).should include("to_yaml")
  end
end
