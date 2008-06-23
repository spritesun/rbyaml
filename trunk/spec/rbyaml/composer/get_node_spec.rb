require File.join(File.dirname(__FILE__), 'composer_helper')

describe "RbYAML:Composer#get_node" do
  it "should get symbol node when compose by symbol string " do
    node = RbYAML::Composer.new_by_string("--- :sym").get_node
    node.value.should == ":sym"
    node.tag.should == "tag:yaml.org,2002:sym"
  end

  it "could escape characters" do
    node = RbYAML::Composer.new_by_string("\xC3\xBC").get_node
    node.value.should == "\xC3\xBC"
    node.tag.should == "tag:yaml.org,2002:str"
  end

  it "should not escape 8-bit unicode to decimal number" do
    node = RbYAML::Composer.new_by_string("\"\\xC3\\xBC\"").get_node
    node.value.should == "\xC3\xBC"
    node.tag.should == "tag:yaml.org,2002:str"
  end
end
