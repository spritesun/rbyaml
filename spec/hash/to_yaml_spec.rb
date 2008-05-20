require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "Hash#to_yaml" do
  it "should has to_yaml method" do
    Hash.instance_methods(false).should include("to_yaml")
  end
end
