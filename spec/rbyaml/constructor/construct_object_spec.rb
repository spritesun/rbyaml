require File.join(File.dirname(__FILE__), 'constructor_helper.rb')

describe "Constructor#construct_object" do
  it "should return symbol data when getting symbol node" do
    constructor = Constructor.new_by_string("--- :sym")
    constructor.construct_object(constructor.composer.get_node).should == :sym
  end

  it "should return symbol data when symbol string contain blank" do
    constructor = Constructor.new_by_string(":user name")
    constructor.construct_object(constructor.composer.get_node).should == :'user name'
  end
end
