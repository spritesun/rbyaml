require File.join(File.dirname(__FILE__), 'constructor_helper.rb')

describe "RbYAML::Constructor#construct_domain_type" do
  it "could_construct_domaintype_by_node" do
    pending
    constructor = RbYAML::Constructor.new_by_string("")
    node = RbYAML::ScalarNode.new("!domain.tld,2002/type0", "value")
    constructor.construct_domain_type(node).class.should == RbYAML::DomainType
  end

  it "should_construct_domaintype_object_when_self_defined_tag" do
    pending
  end
end
