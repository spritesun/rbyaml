# Copyright (c) 2007, Evan Phoenix
# Distributed under BSD License
# Modified by Long Sun

require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "RbYAML.tagged_classes" do
  it "returns a complete dictionary of taguris paired with classes" do
    RbYAML.tagged_classes["tag:yaml.org,2002:int"].should == Integer
  end  
end
