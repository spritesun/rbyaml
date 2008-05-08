require File.join(File.dirname(__FILE__), 'fixtures', 'classes')

describe "RbYAML:Composer#get_node" do
  it "should get symbol node when compose by symbol string " do
    composer = RbYAML::Composer.new_by_string("--- :sym")
    node = composer.get_node
    node.value.should == :sym
    node.tag.should == "tag:yaml.org,2002:sym"
  end
end
