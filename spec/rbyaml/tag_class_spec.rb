# Copyright (c) 2007, Evan Phoenix
# Distributed under BSD License
# Modified by Long Sun

require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "RbYAML.tag_class" do
  it "associates a taguri tag with a ruby class" do
    RbYAML.tag_class('rubini.us','rubinius').should == "rubinius"
  end  
end
