require File.join(File.dirname(__FILE__), "rbyaml_helper")

describe "RbYAML#add_domain_type" do
  after :each do
    load_yaml
  end

  it "should call binding proc when loading domain type which had been added before" do
    load_yaml "1.0"
    RbYAML.add_domain_type( "domain.tld,2002", "type0" ) { |type, val| "ONE: #{val}" }
    "!domain.tld,2002/type0 pat".should load_as("ONE: pat")
  end

end
