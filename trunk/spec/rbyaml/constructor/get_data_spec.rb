require File.join(File.dirname(__FILE__), 'fixtures', 'classes')

describe "RbYAML::Constructor#get_data" do
  it "should return a symbol when getting a symbol stream" do
    constructor = RbYAML::Constructor.new_by_string("--- :sym")
    constructor.get_data.should == :sym
  end
end
