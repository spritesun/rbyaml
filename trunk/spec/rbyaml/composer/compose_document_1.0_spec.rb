require File.join(File.dirname(__FILE__), 'composer_helper')

describe "Composer#compose_document" do
  before :all do
    $global_yaml_version = "1.0"
  end

  after :all do
    $global_yaml_version = "1.1"
  end

  it "should parse !foo form tag as tag:yaml.org,2002:foo" do
    node = "!foo bar".compose_to_node
    node.tag.should == "tag:yaml.org,2002:foo"
  end

  it "should parse !clarkevans.com,2003-02/timesheet form tag as tag:clarkevans.com,2003-02:timesheet" do
    node = "!foo.com,2008-08/bar bla".compose_to_node
    node.tag.should == "tag:foo.com,2008-08:bar"
  end
end

