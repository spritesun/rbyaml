require File.join(File.dirname(__FILE__), "rbyaml_helper")

describe "RbYAML#each_node" do
  it "could iterate each node with given block" do
    RbYAML.each_node("some") { |doc| doc.should == ScalarNode.new(String.new.taguri, "some") }
  end
end
