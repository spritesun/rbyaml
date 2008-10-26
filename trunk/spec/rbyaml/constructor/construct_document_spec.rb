require File.join(File.dirname(__FILE__), 'constructor_helper.rb')

describe "Constructor#construct_document" do
  it "should return symbol data when getting symbol node" do
    constructor = Constructor.new_by_string("--- :sym")
    constructor.construct_document(constructor.composer.get_node).should == :sym
  end

end
