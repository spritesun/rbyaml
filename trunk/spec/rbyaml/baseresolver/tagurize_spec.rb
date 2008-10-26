require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe "BaseResolver#tagurize" do
  before :all do
    BaseResolver = BaseResolver
  end

  it "should do nothing when tagurize non-string object" do
    BaseResolver.tagurize(627).should == 627
  end

  it "should return tag when tagurize string object" do
    BaseResolver.tagurize('new_tag').should == "tag:yaml.org,2002:new_tag"
  end
end
