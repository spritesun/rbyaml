require File.join(File.dirname(__FILE__), 'composer_helper')

describe "Composer#compose_document" do

  after :each do
    load_yaml
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
  it "should parse !foo form tag as tag:yaml.org,2002:foo" do
    load_yaml "1.0"
    node = "!foo bar".compose_to_node
    node.tag.should == "tag:yaml.org,2002:foo"
  end

  it "should parse !clarkevans.com,2003-02/timesheet form tag as tag:clarkevans.com,2003-02:timesheet" do
    load_yaml "1.0"
    node = "!foo.com,2008-08/bar bla".compose_to_node
    node.tag.should == "tag:foo.com,2008-08:bar"
  end

end

class String
  def compose_to_node
    Composer.new_by_string(self).compose_document
  end
end
