require File.join(File.dirname(__FILE__), 'constructor_helper.rb')

describe "RbYAML::Constructor#get_data" do
  it "should return a symbol when getting a symbol stream" do
    constructor = RbYAML::Constructor.new_by_string("--- :sym")
    constructor.get_data.should == :sym
  end

  it "could  escape 8-bit Unicode character" do
    constructor = RbYAML::Constructor.new_by_string("\xC3\xBC")
    constructor.get_data.should == "\303\274"
  end
end
