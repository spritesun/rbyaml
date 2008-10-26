require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe "Scanner#update" do
  it "should not append \0 after update stream" do
    scanner = Scanner.new("---")
    scanner.update(4)
   scanner.buffer.should == "---\0"
  end
end
