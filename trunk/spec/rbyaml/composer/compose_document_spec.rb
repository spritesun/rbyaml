require File.join(File.dirname(__FILE__), 'fixtures', 'classes')

describe "RbYAML:Composer#compose_document" do
  it "should get string value when compose by symbol string" do
    composer = RbYAML::Composer.new_by_string(":sym")
    node = composer.compose_document
    node.value.should == ":sym"
  end
  
  it "should get sym tag when compose by symbol string" do
    composer = RbYAML::Composer.new_by_string(":sym")
    node = composer.compose_document
    node.tag.should == "tag:yaml.org,2002:sym"
  end
  
  it "should get string value when compose by integer string" do
    RbYAML::Composer.new_by_string("12").compose_document.value.should == "12"
  end
  
  it "should get int tag when compose by integer string" do
    RbYAML::Composer.new_by_string("12").compose_document.tag.should == "tag:yaml.org,2002:int"
  end
end
