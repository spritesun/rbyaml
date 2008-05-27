require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe "Scanner#prefix" do
  it "should not append \0 after stream" do
    RbYAML::Scanner.new("---").prefix(4).should == "---\0"
  end
end
