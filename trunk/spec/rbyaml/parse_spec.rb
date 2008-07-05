require File.join(File.dirname(__FILE__), "rbyaml_helper")

describe "RbYAML#parse" do
  it "should parse string text to scalar node" do
    text = "chenderong"
    RbYAML.parse(text).should == RbYAML::ScalarNode.new(String.new.taguri, text)
  end
end
