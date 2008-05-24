require File.join(File.dirname(__FILE__), 'constructor_helper.rb')

describe "RbYAML::Constructor#construct_yaml_sym" do
  before :all do
    @constructor = RbYAML::Constructor.new(nil)
    @sym_node = RbYAML::ScalarNode.new(nil, ":sym")
    @colon_name_sym_node = RbYAML::ScalarNode.new(nil, ":C:/tmp")
    @blank_sym_node = RbYAML::ScalarNode.new(nil, ":first name")
  end

  it "should get symbol value when node is symbol" do
    @constructor.construct_yaml_sym(@sym_node).should == :sym
  end

  it "can parse a symbol node which contain colon" do
    @constructor.construct_yaml_sym(@colon_name_sym_node).should == :'C:/tmp'
  end

  it "should parse symbol which contain blank" do
    @constructor.construct_yaml_sym(@blank_sym_node).should == :"first name"
  end
end
