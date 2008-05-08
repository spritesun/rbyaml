require File.join(File.dirname(__FILE__), 'fixtures', 'classes')

describe "RbYAML:Constructor#construct_object" do
  it "should return symbol data when getting symbol node" do
    constructor = RbYAML::Constructor.new_by_string("--- :sym")
    constructor.construct_object(constructor.composer.get_node).should == :sym
  end
end
