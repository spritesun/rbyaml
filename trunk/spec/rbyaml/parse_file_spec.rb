require File.join(File.dirname(__FILE__), "rbyaml_helper")

describe "RbYAML#parse_file" do
  after :each do
    File.delete $test_file if File.exist? $test_file
  end

  it "should parse file by filepath" do
    File.open($test_file, 'w') do |io|
      RbYAML.dump("some", io )
    end

    RbYAML.parse_file($test_file).should == RbYAML::ScalarNode.new(String.new.taguri, "some")
  end

end
