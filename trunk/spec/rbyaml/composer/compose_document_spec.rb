require File.join(File.dirname(__FILE__), 'composer_helper')

describe "RbYAML:Composer#compose_document" do
  before :each do
    @sym_composer = RbYAML::Composer.new_by_string(":sym")
    @int_composer = RbYAML::Composer.new_by_string("12")
  end

  it "should get symbol node when compose by symbol string" do
    node = ":sym".compose_to_node
    node.value.should == ":sym"
    node.tag.should == "tag:yaml.org,2002:sym"
  end

  it "should get integer node when compose by integer string" do
    node = "12".compose_to_node
    node.value.should == "12"
    node.tag.should == "tag:yaml.org,2002:int"
  end

  it "should get object node when composing by empty string" do
    node = "".compose_to_node
    node.tag.should == "tag:yaml.org,2002:null"
    node.value.should == ""
  end
end

class String
  def compose_to_node
    RbYAML::Composer.new_by_string(self).compose_document
  end
end
