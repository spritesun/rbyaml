require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "RbYAML#_load" do
  it "should return a symbol when loading a symbol" do
    RbYAML._load("--- :sym").should == :sym
  end
end
