require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe "Node#transform" do
  it "should transform string scalar node to string" do
    ScalarNode.new(String.new.taguri, "chengderong").transform.should == "chengderong"
  end

  it "could transform symbol" do
    ScalarNode.new(RbYAML.tagurize("sym"), ":\"^foo\"").transform.should == :"^foo"
  end
end
