require File.join(File.dirname(__FILE__), "rbyaml_helper")

describe "RbYAML.dump" do
  before :all do
    $global_yaml_version = "1.0"
  end

  after :all do
    $global_yaml_version = "1.1"
  end

  it "should be able to dump yaml 1.0 tag" do
    RbYAML.dump(1, nil, { :ExplicitTypes => true} ).should == "--- !int 1\n"
  end

  it "could dump by options during version1.0" do
    obj = { "1" => 2 }
    RbYAML.dump(obj, nil, :UseVersion => true, :UseHeader => true, :SortKeys => true ).should == "%YAML 1.0\n--- \n!str 1: 2\n"
  end
end
