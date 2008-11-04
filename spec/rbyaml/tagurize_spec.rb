# Copyright (c) 2007, Evan Phoenix
# Distributed under BSD License
# Modified by Long Sun

require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "RbYAML.tagurize" do
  it "should converts a type_id to a taguri" do
    no_warning RbYAML.tagurize('wtf').should == "tag:yaml.org,2002:wtf"
    RbYAML.tagurize(1).should == 1
  end
end
