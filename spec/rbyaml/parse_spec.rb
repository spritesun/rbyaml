require File.join(File.dirname(__FILE__), "rbyaml_helper")

describe "RbYAML#parse" do
  it "should parse string text to scalar node" do
    RbYAML.parse("---\nchenderong").should == ScalarNode.new(String.new.taguri, "chenderong")
  end
end
