require File.join(File.dirname(__FILE__), 'fixtures', 'classes')

describe "RbYAML::Constructor#construct_yaml_sym" do
  before :all do
    @constructor = RbYAML::Constructor.new(nil)
    @sym_node = RbYAML::ScalarNode.new(nil, ":sym")
    @colon_name_sym_node = RbYAML::ScalarNode.new(nil, ":C:/tmp")
  end
  
  it "should get symbol value when node is symbol" do
    @constructor.construct_yaml_sym(@sym_node).should == :sym
  end

  it "can parse a symbol node which contain colon" do
    @constructor.construct_yaml_sym(@colon_name_sym_node).should == :"C:/tmp"
  end
end
