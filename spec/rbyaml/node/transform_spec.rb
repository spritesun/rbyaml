require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe "Node#transform" do
  it "should transform string scalar node to string" do
    text = "chengderong"
    RbYAML::ScalarNode.new(String.new.taguri, text).transform.should == text
  end
end
