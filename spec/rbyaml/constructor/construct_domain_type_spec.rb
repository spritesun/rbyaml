require File.join(File.dirname(__FILE__), 'constructor_helper.rb')

describe "RbYAML::Constructor#construct_domain_type" do
  it "could_construct_domaintype_by_node_object" do
    constructor = RbYAML::Constructor.new_by_string("")
    node = RbYAML::ScalarNode.new("tag:domain.tld,2002/type0", "value")
    constructor.construct_domain_type(node).class.should == RbYAML::DomainType
  end

end
