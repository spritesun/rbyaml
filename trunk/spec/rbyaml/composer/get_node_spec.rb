require File.join(File.dirname(__FILE__), 'composer_helper')

describe "Composer#get_node" do

  before :all do
    SYM_TAG = RbYAML.tagurize("sym")
    STR_TAG = RbYAML.tagurize("str")
  end

  it "should get symbol node when compose by symbol string " do
    node = Composer.new_by_string("--- :sym").get_node
    no_warning node.value.should == ":sym"
    node.tag.should == SYM_TAG
  end

  it "could escape characters" do
    node = Composer.new_by_string("\xC3\xBC").get_node
    no_warning node.value.should == "\xC3\xBC"
    node.tag.should == STR_TAG
  end

  it "should not escape 8-bit unicode to decimal number" do
    node = Composer.new_by_string("\"\\xC3\\xBC\"").get_node
    no_warning node.value.should == "\xC3\xBC"
    node.tag.should == STR_TAG
  end

  it "could get node by symbol" do
    node = Composer.new_by_string("--- :\"^foo\"\n").get_node
    no_warning node.value.should == ":\"^foo\""
    node.tag.should == SYM_TAG
  end

end
