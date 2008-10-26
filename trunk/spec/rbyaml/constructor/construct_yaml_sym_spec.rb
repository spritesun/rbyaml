require File.join(File.dirname(__FILE__), 'constructor_helper.rb')

describe "Constructor#construct_yaml_sym" do

  before :all do
    @constructor = Constructor.new(nil)
  end

  it "should get symbol value when node is symbol" do
    @constructor.construct_yaml_sym(new_sym_node(":sym")).should == :sym
  end

  it "could parse a symbol node which contain colon" do
    @constructor.construct_yaml_sym(new_sym_node(":C:/tmp")).should == :'C:/tmp'
  end

  it "should parse symbol which contain blank" do
    @constructor.construct_yaml_sym(new_sym_node(":first name")).should == :'first name'
  end

  it "could parse symbol which contains strange string" do
    @constructor.construct_yaml_sym(new_sym_node(":\"^str\"")).should == :'^str'
  end

end

def new_sym_node stream
  ScalarNode.new(RbYAML.tagurize("sym"), stream)
end
