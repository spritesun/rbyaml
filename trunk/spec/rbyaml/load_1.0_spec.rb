require File.join(File.dirname(__FILE__), "rbyaml_helper")

describe "RbYAML#load" do
  before :all do
    $global_yaml_version = "1.0"
  end

  after :all do
    $global_yaml_version = "1.1"
  end

  it "should load !str as application tag in YAML1.0" do
    "!str str".should load_as("str")
    "!str 1.0".should load_as("1.0")
  end

  it "should load string with empty value as empty string" do
    "---\n!str".should load_as(String.new)
  end

  it "should load able to parse taguri as yaml 1.0" do
    authorityName = "domain.com"
    date = "2002"
    domain = "#{authorityName},#{date}"
    specific = "type0"
    value = "just a value"

    "!#{domain}/#{specific} #{value}".should load_as(DomainType.new(domain, specific, value))
  end
end
