require File.join(File.dirname(__FILE__), "rbyaml_helper")

describe "RbYAML#add_domain_type" do
  before :each do
    # Currently add_domain_type doesn't make any sense to YAML 1.1
    load_yaml "1.0"
  end

  after :each do
    load_yaml
  end

  it "should call binding proc when loading domain type which had been added before" do
    RbYAML.add_domain_type( "domain.tld,2002", "type0" ) { |type, val| "ONE: #{val}" }
    "!domain.tld,2002/type0 pat".should load_as("ONE: pat")
  end

  it "should escape tag" do
    RbYAML.add_domain_type( "domain.tld,2002", "type0" ) { |type, val| "ONE: #{val}" }
    "!domain.tld,2002/type\x30 value".should load_as("ONE: value")
  end

  it "should not do uri escape" do
    RbYAML.add_domain_type( "domain.tld,2002", "type%30" ) { |type, val| "TWO: #{val}" }
    "!domain.tld,2002/type%30 value".should load_as("TWO: value")
  end

  it "should escape \"\\\\x30\" to \"0\"" do
    pending
    RbYAML.add_domain_type( "domain.tld,2002", "type0" ) { |type, val| "ONE: #{val}" }
    "!domain.tld,2002/type\\x30 value".should load_as("ONE: value")
  end
end
